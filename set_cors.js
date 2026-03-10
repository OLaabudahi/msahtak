// Script to set CORS on Firebase Storage bucket
// Uses the Google Cloud Storage JSON API with Firebase CLI auth token

const { execSync } = require('child_process');
const https = require('https');

// Get access token from Firebase CLI config
const os = require('os');
const path = require('path');
const fs = require('fs');

let token = null;
try {
  // Firebase CLI stores tokens in config files
  const configPath = path.join(os.homedir(), '.config', 'configstore', 'firebase-tools.json');
  if (fs.existsSync(configPath)) {
    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    token = config.tokens?.access_token || config.user?.tokens?.access_token;
  }
} catch (e) {}

if (!token) {
  try {
    // Try getting token via firebase CLI
    const result = execSync('firebase auth:token 2>/dev/null || firebase experimental:token 2>/dev/null', { encoding: 'utf8' }).trim();
    token = result;
  } catch (e) {}
}

if (!token) {
  console.error('Could not get auth token. Please set CORS manually via Google Cloud Console.');
  console.error('Go to: https://console.cloud.google.com/storage/browser/masahatak-73bf9.firebasestorage.app');
  process.exit(1);
}

const corsConfig = JSON.stringify([
  {
    origin: ['*'],
    method: ['GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'OPTIONS'],
    maxAgeSeconds: 3600,
    responseHeader: ['Content-Type', 'Authorization', 'x-goog-resumable'],
  },
]);

const bucketName = 'masahatak-73bf9.firebasestorage.app';
const options = {
  hostname: 'storage.googleapis.com',
  path: `/storage/v1/b/${encodeURIComponent(bucketName)}?fields=cors`,
  method: 'PATCH',
  headers: {
    Authorization: `Bearer ${token}`,
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(JSON.stringify({ cors: JSON.parse(corsConfig) })),
  },
};

const body = JSON.stringify({ cors: JSON.parse(corsConfig) });

const req = https.request(options, (res) => {
  let data = '';
  res.on('data', (chunk) => (data += chunk));
  res.on('end', () => {
    if (res.statusCode === 200) {
      console.log('✅ CORS set successfully!');
      console.log(data);
    } else {
      console.error(`❌ Failed (${res.statusCode}):`, data);
    }
  });
});

req.on('error', (e) => console.error('Request error:', e));
req.write(body);
req.end();
