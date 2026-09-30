import express from 'express';
import cors from 'cors';
import mqtt from 'mqtt';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { v4 as uuidv4 } from 'uuid';

import { deviceRoutes } from './routes/devices.js';
import { setupSSE, addSSEClient, broadcastEvent } from './sse.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const MQTT_BROKER = process.env.MQTT_BROKER || 'mqtt://localhost:1883';
const PORT = process.env.PORT || 3000;

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(join(__dirname, '../public')));

let mqttClient = null;

function connectMQTT() {
  
  mqttClient = mqtt.connect(MQTT_BROKER, {
    // Generate a unique client ID for this MQTT connection
    clientId: `security-monitor-${uuidv4().slice(0, 8)}`,
    reconnectPeriod: 3000,
    connectTimeout: 10000,
  });

  // Handle MQTT connection establishment
  mqttClient.on('connect', () => {
    console.log('Connected to MQTT broker at', MQTT_BROKER);
    mqttClient.subscribe('security/#', { qos: 1 }, (err) => {
      if (err) console.error('Subscribe error:', err);
    });
  });

  // Handle incoming MQTT errors
  mqttClient.on('error', (err) => {
    console.error('MQTT error:', err.message);
  });

  // Handle MQTT connection close event
  mqttClient.on('close', () => {
    console.log('MQTT connection closed');
  });

  mqttClient.on('reconnect', () => {
    console.log('MQTT reconnecting...');
  });

  return mqttClient;
}

const mqttClientInstance = connectMQTT();

const { getState, getDevices, updateDevice, handleMqttMessage } = deviceRoutes(
  mqttClientInstance,
  broadcastEvent,
);

setupSSE(mqttClientInstance, handleMqttMessage);

app.get('/api/events', (req, res) => addSSEClient(res, getState));
app.get('/api/devices', getDevices);
app.patch('/api/devices/:id', updateDevice);

app.listen(PORT, () => {
  console.log(`Security Monitor running at http://localhost:${PORT}`);
  console.log(`Admin:           http://localhost:${PORT}/admin.html`);
  console.log(`Viewer:          http://localhost:${PORT}/viewer.html`);
});