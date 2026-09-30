const DEVICE_DEFINITIONS = [
  { id: 'fire-detector', name: 'Detector de fuego', type: 'fire', initialValue: false },
  { id: 'water-level', name: 'Nivel de agua', type: 'water', initialValue: 'normal' },
  { id: 'operator-presence', name: 'Presencia del operador', type: 'presence', initialValue: 'present' },
  { id: 'motor', name: 'Estado del motor', type: 'motor', initialValue: 'off' },
];

const VALID_VALUES = {
  fire: [true, false],
  water: ['normal', 'high'],
  presence: ['present', 'absent'],
  motor: ['on', 'off'],
};

function createInitialDevices() {
  const updatedAt = new Date().toISOString();
  return new Map(DEVICE_DEFINITIONS.map((definition) => [definition.id, {
    id: definition.id,
    name: definition.name,
    type: definition.type,
    value: definition.initialValue,
    updatedAt,
  }]));
}

function getAlarm(devices) {
  const values = new Map(devices.map((device) => [device.id, device.value]));
  const causes = [];

  if (values.get('fire-detector') === true) causes.push('fire_detected');
  if (values.get('water-level') === 'high') causes.push('water_high');
  if (values.get('motor') === 'on' && values.get('operator-presence') === 'absent') {
    causes.push('motor_on_without_operator');
  }

  return { active: causes.length > 0, causes };
}

function isValidValue(device, value) {
  return VALID_VALUES[device.type].includes(value);
}

function publish(client, topic, payload) {
  return new Promise((resolve, reject) => {
    if (!client?.connected) {
      reject(new Error('MQTT broker is not connected'));
      return;
    }

    client.publish(topic, JSON.stringify(payload), { qos: 1, retain: false }, (error) => {
      if (error) reject(error);
      else resolve();
    });
  });
}

export function deviceRoutes(mqttClient, emitEvent = () => {}) {
  const devices = createInitialDevices();

  function getState() {
    const list = Array.from(devices.values());
    return {
      devices: list,
      alarm: getAlarm(list),
      updatedAt: list.reduce((latest, device) => (
        device.updatedAt > latest ? device.updatedAt : latest
      ), ''),
    };
  }

  function updateState(deviceId, value, updatedAt, source) {
    const device = devices.get(deviceId);
    if (!device || !isValidValue(device, value)) return null;
    if (device.value === value && device.updatedAt === updatedAt) return null;

    devices.set(deviceId, { ...device, value, updatedAt });
    const event = {
      type: 'update',
      state: getState(),
      changedDeviceId: deviceId,
      source,
    };
    emitEvent(event);
    return event;
  }

  return {
    getState,

    getDevices: (_req, res) => res.json(getState()),

    updateDevice: async (req, res) => {
      const device = devices.get(req.params.id);
      if (!device) return res.status(404).json({ error: 'Dispositivo no encontrado' });

      const value = req.body?.value;
      if (!isValidValue(device, value)) {
        return res.status(400).json({ error: 'Estado no válido para este dispositivo' });
      }

      const updatedAt = new Date().toISOString();
      const payload = { deviceId: device.id, value, updatedAt, source: 'admin' };
      const candidateDevices = Array.from(devices.values(), (current) => (
        current.id === device.id ? { ...current, value, updatedAt } : current
      ));
      try {
        await Promise.all([
          publish(mqttClient, `security/devices/${device.id}/state`, payload),
          publish(mqttClient, 'security/alarm/state', {
            ...getAlarm(candidateDevices),
            updatedAt,
          }),
        ]);
      } catch (error) {
        return res.status(503).json({ error: error.message });
      }

      updateState(device.id, value, updatedAt, 'admin');
      return res.json(getState());
    },

    handleMqttMessage: (topic, message) => {
      const match = /^security\/devices\/([^/]+)\/state$/.exec(topic);
      if (!match) return null;

      try {
        const payload = JSON.parse(message);
        const updatedAt = typeof payload.updatedAt === 'string'
          && !Number.isNaN(Date.parse(payload.updatedAt))
          ? payload.updatedAt
          : new Date().toISOString();
        const source = payload.source === 'admin' ? 'admin' : 'mqtt';
        const event = updateState(match[1], payload.value, updatedAt, source);
        if (event) {
          publish(mqttClient, 'security/alarm/state', {
            ...event.state.alarm,
            updatedAt,
          }).catch((error) => console.error('No se pudo publicar la alarma MQTT:', error.message));
        }
        return event;
      } catch (error) {
        console.error('Mensaje MQTT de dispositivo inválido:', error.message);
        return null;
      }
    },
  };
}