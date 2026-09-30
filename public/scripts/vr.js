const API = '/api';
const COLORS = { normal: '#63d69a', warning: '#f4c85e', alert: '#ff6258', water: '#54b9db', motor: '#9aa9ff', presence: '#65c6c1' };
const VALUE_LABELS = {
  fire: { false: 'SIN FUEGO', true: 'FUEGO DETECTADO' },
  water: { normal: 'NIVEL NORMAL', high: 'NIVEL ALTO' },
  presence: { present: 'OPERADOR PRESENTE', absent: 'OPERADOR AUSENTE' },
  motor: { off: 'MOTOR APAGADO', on: 'MOTOR ENCENDIDO' },
};
const POSITIONS = [[-1.5, -1.1], [1.5, -1.1], [-1.5, 1.1], [1.5, 1.1]];
const scene = document.getElementById('sensorScene');
const stationRoot = document.getElementById('sensorStations');
const stations = new Map();
let currentState;

function makeEntity(tag, attributes = {}) {
  const entity = document.createElement(tag);
  Object.entries(attributes).forEach(([name, value]) => entity.setAttribute(name, value));
  return entity;
}

function addShape(parent, tag, attributes = {}) {
  const shape = makeEntity(tag, attributes);
  parent.append(shape);
  return shape;
}

function addSensorModel(root, type) {
  if (type === 'fire') {
    addShape(root, 'a-cone', { position: '0 0.78 0', 'radius-bottom': '0.34', 'radius-top': '0.06', height: '0.76', color: COLORS.alert, material: 'roughness: 0.35' });
    addShape(root, 'a-sphere', { position: '0 0.48 0', radius: '0.22', color: '#ffad59' });
  } else if (type === 'water') {
    addShape(root, 'a-cylinder', { position: '0 0.72 0', radius: '0.34', height: '0.78', color: COLORS.water, material: 'roughness: 0.25; metalness: 0.18' });
    addShape(root, 'a-torus', { position: '0 0.85 0', rotation: '90 0 0', radius: '0.36', 'radius-tubular': '0.035', color: '#d8f6fc' });
  } else if (type === 'presence') {
    addShape(root, 'a-sphere', { position: '0 1.12 0', radius: '0.2', color: COLORS.presence });
    addShape(root, 'a-cylinder', { position: '0 0.65 0', radius: '0.27', height: '0.62', color: COLORS.presence });
    addShape(root, 'a-box', { position: '-0.24 0.65 0', rotation: '0 0 -18', width: '0.13', height: '0.52', depth: '0.14', color: COLORS.presence });
    addShape(root, 'a-box', { position: '0.24 0.65 0', rotation: '0 0 18', width: '0.13', height: '0.52', depth: '0.14', color: COLORS.presence });
  } else {
    const motorHousing = addShape(root, 'a-cylinder', { position: '0 0.7 0', radius: '0.32', height: '0.56', color: COLORS.motor, rotation: '90 0 0', material: 'roughness: 0.35; metalness: 0.35' });
    addShape(root, 'a-cylinder', { position: '0 0.7 0.2', radius: '0.13', height: '0.09', color: '#d9dcff' });
    const rotor = makeEntity('a-entity', { position: '0 0.7 0' });
    for (let index = 0; index < 4; index += 1) {
      addShape(rotor, 'a-box', { rotation: `0 0 ${index * 45}`, width: '0.65', height: '0.07', depth: '0.09', color: COLORS.motor });
    }
    root.append(rotor);
    return { motorRotor: rotor, motorHousing };
  }
}

function createStation(device, index) {
  const [x, z] = POSITIONS[index % POSITIONS.length];
  const root = makeEntity('a-entity', { position: `${x} 0 ${z}`, 'data-device-id': device.id });
  addShape(root, 'a-cylinder', { position: '0 0.08 0', radius: '0.59', height: '0.16', color: '#293c37', material: 'roughness: 0.72; metalness: 0.24' });
  addShape(root, 'a-torus', { position: '0 0.17 0', rotation: '90 0 0', radius: '0.48', 'radius-tubular': '0.018', color: '#47736b' });
  const model = makeEntity('a-entity');
  root.append(model);
  const motorParts = addSensorModel(model, device.type) || {};
  const beacon = addShape(root, 'a-sphere', { position: '0 1.48 0', radius: '0.09', color: COLORS.normal, material: `emissive: ${COLORS.normal}; emissiveIntensity: 0.8` });
  const name = addShape(root, 'a-text', { position: '0 1.83 0', align: 'center', anchor: 'center', width: '2.6', color: '#f1f3e9', 'wrap-count': '24', font: 'mozillavr' });
  name.setAttribute('text', 'value', device.name);
  const reading = addShape(root, 'a-text', { position: '0 0.38 0', align: 'center', anchor: 'center', width: '2.5', color: COLORS.normal, 'wrap-count': '28', font: 'mozillavr' });
  const elements = { root, model, beacon, reading, ...motorParts };
  stations.set(device.id, elements);
  stationRoot.append(root);
  updateStation(device, elements);
}

function isAlerting(device, devices) {
  if (device.type === 'fire') return device.value === true;
  if (device.type === 'water') return device.value === 'high';
  if (device.type === 'presence') return device.value === 'absent' && devices.some(({ type, value }) => type === 'motor' && value === 'on');
  if (device.type === 'motor') return device.value === 'on' && devices.some(({ type, value }) => type === 'presence' && value === 'absent');
  return false;
}

function updateStation(device, elements, devices = currentState?.devices || []) {
  const alarming = isAlerting(device, devices);
  const warning = device.type === 'presence' && device.value === 'absent' && !alarming;
  const color = alarming ? COLORS.alert : warning ? COLORS.warning : COLORS[device.type] || COLORS.normal;
  elements.beacon.setAttribute('material', { color, emissive: color, emissiveIntensity: 0.8 });
  elements.reading.setAttribute('text', 'value', VALUE_LABELS[device.type]?.[String(device.value)] || 'ESTADO DESCONOCIDO');
  elements.reading.setAttribute('text', 'color', color);
  if (device.type === 'motor') {
    const running = device.value === 'on';
    elements.model.object3D.scale.setScalar(running ? 1.16 : 1);
    if (running) {
      elements.motorRotor.setAttribute('animation', { property: 'rotation', from: '0 0 0', to: '0 0 360', dur: 720, easing: 'linear', loop: true });
    } else {
      elements.motorRotor.removeAttribute('animation');
      elements.motorRotor.object3D.rotation.set(0, 0, 0);
    }
    elements.motorHousing.setAttribute('material', 'color', running ? '#59e0ad' : COLORS.motor);
    elements.motorRotor.querySelectorAll('a-box').forEach((blade) => {
      blade.setAttribute('color', running ? '#59e0ad' : COLORS.motor);
    });
  }
}

function renderState(state) {
  if (!state || !Array.isArray(state.devices)) return;
  state.devices.forEach((device, index) => {
    if (!stations.has(device.id)) createStation(device, index);
  });
  currentState = state;
  state.devices.forEach((device) => updateStation(device, stations.get(device.id), state.devices));

  const alarm = document.getElementById('alarmState');
  const active = Boolean(state.alarm?.active);
  alarm.classList.toggle('active', active);
  alarm.classList.toggle('normal', !active);
  alarm.classList.remove('unknown');
  document.getElementById('alarmText').textContent = active ? 'ALARMA ACTIVA' : 'SISTEMA NORMAL';
  document.getElementById('alarmSiren').setAttribute('visible', active);
}

function setConnection(connected) {
  const status = document.getElementById('connectionStatus');
  status.classList.toggle('connected', connected);
  status.classList.toggle('disconnected', !connected);
  document.getElementById('connectionText').textContent = connected ? 'CANAL EN VIVO' : 'REINTENTANDO CONEXIÓN';
}

async function loadState() {
  const response = await fetch(`${API}/devices`);
  if (!response.ok) throw new Error('No se pudo cargar el estado');
  renderState(await response.json());
}

function connectEvents() {
  const stream = new EventSource(`${API}/events`);
  stream.onopen = () => setConnection(true);
  stream.onerror = () => setConnection(false);
  stream.onmessage = (message) => {
    try {
      renderState(JSON.parse(message.data).state);
    } catch {
      setConnection(false);
    }
  };
}

function showSceneError() {
  document.getElementById('sceneError').hidden = false;
  document.getElementById('connectionText').textContent = 'ESCENA 3D NO DISPONIBLE';
  document.getElementById('alarmText').textContent = 'ESTADO SIN CARGAR';
  document.getElementById('alarmState').classList.add('unknown');
}

if (!window.AFRAME) {
  showSceneError();
} else {
  const initializeScene = () => {
    loadState().catch(() => {
      document.getElementById('alarmText').textContent = 'NO SE PUDO CARGAR EL ESTADO';
      document.getElementById('alarmState').classList.add('unknown');
    }).finally(connectEvents);
  };
  if (scene.hasLoaded) initializeScene();
  else scene.addEventListener('loaded', initializeScene, { once: true });
}