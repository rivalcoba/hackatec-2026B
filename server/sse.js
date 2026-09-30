const clients = new Set();

export function broadcastEvent(event) {
  const data = `data: ${JSON.stringify(event)}\n\n`;
  clients.forEach((res) => {
    try {
      res.write(data);
    } catch (error) {
      clients.delete(res);
    }
  });
}

export function setupSSE(mqttClient, handleMqttMessage) {
  if (!mqttClient) return;

  mqttClient.on('message', (topic, message) => {
    handleMqttMessage(topic, message.toString());
  });
}

export function addSSEClient(res, getSnapshot) {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no');
  res.flushHeaders();

  clients.add(res);
  res.write(`data: ${JSON.stringify({ type: 'snapshot', state: getSnapshot() })}\n\n`);

  res.on('close', () => {
    clients.delete(res);
  });
}