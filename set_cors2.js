// Set CORS on Firebase Storage using @google-cloud/storage with Firebase CLI auth token
const { Storage } = require('@google-cloud/storage');
const os = require('os');
const path = require('path');
const fs = require('fs');

// Read Firebase CLI access token
const configPath = path.join(os.homedir(), '.config', 'configstore', 'firebase-tools.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
const accessToken = config.tokens?.access_token;

if (!accessToken) {
  console.error('No access token found. Run: firebase login');
  process.exit(1);
}

// Use the token as application credentials
process.env.GOOGLE_CLOUD_UNIVERSE_DOMAIN = 'googleapis.com';

const { GoogleAuth } = require('google-auth-library');

async function setCors() {
  // Create a custom auth using the Firebase CLI token
  const storage = new Storage({
    authClient: {
      getRequestHeaders: async () => ({
        Authorization: `Bearer ${accessToken}`,
      }),
    },
    projectId: 'masahatak-73bf9',
  });

  const buckets = [
    'masahatak-73bf9.firebasestorage.app',
    'masahatak-73bf9.appspot.com',
  ];

  const corsConfig = [
    {
      origin: ['*'],
      method: ['GET', 'POST', 'PUT', 'DELETE', 'HEAD', 'OPTIONS'],
      maxAgeSeconds: 3600,
      responseHeader: ['Content-Type', 'Authorization', 'x-goog-resumable'],
    },
  ];

  for (const bucketName of buckets) {
    try {
      const bucket = storage.bucket(bucketName);
      await bucket.setCorsConfiguration(corsConfig);
      console.log(`✅ CORS set on: ${bucketName}`);
    } catch (e) {
      console.log(`❌ ${bucketName}: ${e.message}`);
    }
  }
}

setCors().catch(console.error);
