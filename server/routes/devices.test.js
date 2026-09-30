import test from 'node:test';
import assert from 'node:assert/strict';

import { deviceRoutes } from './devices.js';

function createResponse() {
  return {
    statusCode: 200,
    body: null,
    status(code) {
      this.statusCode = code;
      return this;
    },
    json(body) {
      this.body = body;
      return this;
    },
  };
}

function createHarness(connected = true) {
  const messages = [];
  const events = [];
  const client = {
    connected,
    publish(topic, message, options, callback) {
      messages.push({ topic, payload: JSON.parse(message), options });
      callback();
    },
  };
  return {
    messages,
    events,
    routes: deviceRoutes(client, (event) => events.push(event)),
  };
}

test('starts with the four safe device states and no alarm', () => {
  const { routes } = createHarness();
  const state = routes.getState();

  assert.deepEqual(state.devices.map(({ id, value }) => [id, value]), [
    ['fire-detector', false],
    ['water-level', 'normal'],
    ['operator-presence', 'present'],
    ['motor', 'off'],
  ]);
  assert.deepEqual(state.alarm, { active: false, causes: [] });
});

test('publishes valid admin updates and derives the motor/operator alarm', async () => {
  const { routes, messages, events } = createHarness();
  const operatorResponse = createResponse();
  await routes.updateDevice({ params: { id: 'operator-presence' }, body: { value: 'absent' } }, operatorResponse);
  const motorResponse = createResponse();
  await routes.updateDevice({ params: { id: 'motor' }, body: { value: 'on' } }, motorResponse);

  assert.equal(motorResponse.statusCode, 200);
  assert.deepEqual(motorResponse.body.alarm, {
    active: true,
    causes: ['motor_on_without_operator'],
  });
  const deviceMessage = messages.find(({ topic }) => topic === 'security/devices/motor/state');
  const alarmMessage = messages.filter(({ topic }) => topic === 'security/alarm/state').at(-1);
  assert.equal(deviceMessage.options.qos, 1);
  assert.equal(deviceMessage.options.retain, false);
  assert.equal(deviceMessage.payload.source, 'admin');
  assert.deepEqual(alarmMessage.payload.causes, ['motor_on_without_operator']);
  assert.equal(events.at(-1).source, 'admin');
});

test('marks fire and high water as alarm causes', async () => {
  const { routes } = createHarness();
  const fireResponse = createResponse();
  await routes.updateDevice({ params: { id: 'fire-detector' }, body: { value: true } }, fireResponse);
  const waterResponse = createResponse();
  await routes.updateDevice({ params: { id: 'water-level' }, body: { value: 'high' } }, waterResponse);

  assert.deepEqual(waterResponse.body.alarm, {
    active: true,
    causes: ['fire_detected', 'water_high'],
  });
});

test('rejects unknown devices, invalid values, and updates while MQTT is disconnected', async () => {
  const { routes, messages } = createHarness();
  const unknownResponse = createResponse();
  await routes.updateDevice({ params: { id: 'unknown' }, body: { value: 'on' } }, unknownResponse);
  const invalidResponse = createResponse();
  await routes.updateDevice({ params: { id: 'water-level' }, body: { value: 100 } }, invalidResponse);
  const offlineRoutes = createHarness(false).routes;
  const offlineResponse = createResponse();
  await offlineRoutes.updateDevice({ params: { id: 'motor' }, body: { value: 'on' } }, offlineResponse);

  assert.equal(unknownResponse.statusCode, 404);
  assert.equal(invalidResponse.statusCode, 400);
  assert.equal(offlineResponse.statusCode, 503);
  assert.equal(messages.length, 0);
});

test('accepts valid external MQTT updates and ignores invalid payloads', () => {
  const { routes, events } = createHarness();
  const update = routes.handleMqttMessage(
    'security/devices/water-level/state',
    JSON.stringify({ value: 'high' }),
  );
  const invalid = routes.handleMqttMessage(
    'security/devices/motor/state',
    JSON.stringify({ value: 'running' }),
  );

  assert.equal(update.source, 'mqtt');
  assert.deepEqual(update.state.alarm.causes, ['water_high']);
  assert.equal(invalid, null);
  assert.equal(events.length, 1);
});