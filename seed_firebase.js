/**
 * seed_firebase.js
 *
 * USAGE:
 * 1. Go to Firebase Console → Project Settings → Service accounts
 * 2. Click "Generate new private key" → download the JSON file
 * 3. Place it in this folder and rename it: serviceAccountKey.json
 * 4. Set YOUR_USER_ID below to your Firebase Auth UID
 *    (find it in Firebase Console → Authentication → Users)
 * 5. Run: node seed_firebase.js
 */

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// ── CHANGE THIS to your real Firebase Auth UID ──────────────────────────────
const USER_ID = 'zECaOgFvdibxuox424DYbEqXmgA2';
// ────────────────────────────────────────────────────────────────────────────

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seed() {
  console.log('🌱 Seeding Firebase...\n');

  // ────────────────────────────────────────────────────────────────────────
  // 1. USERS
  // ────────────────────────────────────────────────────────────────────────
  await db.collection('users').doc(USER_ID).set({
    full_name: 'مؤمن الأحمد',
    email: 'momen@example.com',
    phone_number: '+966501234567',
    avatar_url: null,
    totalBookings: 5,
    completedBookings: 3,
    savedSpaces: 2,
  });
  console.log('✅ users');

  // ────────────────────────────────────────────────────────────────────────
  // 2. WORKSPACES
  // ────────────────────────────────────────────────────────────────────────
  const workspaces = [
    {
      id: 'ws_001',
      data: {
        name: 'Masahtak Hub - Riyadh',
        subtitle: 'Modern coworking in the heart of Riyadh',
        subtitleLine: '⭐ 4.8 · 2.3 km away · SAR 120/day',
        rating: 4.8,
        price_per_day: 120,
        currency: 'SAR',
        location: new admin.firestore.GeoPoint(24.7136, 46.6753),
        image_url: null,
        images: [],
        features: ['High-speed WiFi', 'Private rooms', 'Meeting rooms', 'Coffee bar', 'Printing'],
        usage_stats: [
          { label: 'Quiet level', percent: 80 },
          { label: 'WiFi speed', percent: 95 },
          { label: 'Seat availability', percent: 70 },
        ],
        why_people_come: ['Deep focus work', 'Team meetings', 'Study sessions'],
        review_summary: {
          header: 'Great space for focused work',
          meta: 'Based on 48 reviews',
          top_positives: ['Very quiet', 'Fast internet', 'Comfortable seats'],
          repeated_negatives: ['Limited parking', 'Expensive coffee'],
          crowd_level: 'Moderate',
          noise: 'Low',
        },
        latest_reviews: [
          {
            id: 'rv_1',
            user_name: 'سالم العتيبي',
            time_ago: '2 days ago',
            stars: 5,
            comment: 'Excellent space, very quiet and productive.',
          },
          {
            id: 'rv_2',
            user_name: 'ريم الشمري',
            time_ago: '1 week ago',
            stars: 4,
            comment: 'Good internet, nice atmosphere.',
          },
        ],
        offers: [
          {
            id: 'off_1',
            badge_text: 'HOT DEAL',
            badge_type: 'hot',
            title: 'Weekly Pass',
            price_line: 'SAR 500 / week',
            old_price_text: 'SAR 840',
            new_price_text: 'SAR 500',
            includes_text: 'Unlimited access, meeting room 2h/day',
            valid_until_text: 'Valid until end of month',
          },
        ],
        policies: {
          title: 'Booking Policy',
          subtitle: 'Please read before booking',
          sections: [
            {
              title: 'Cancellation',
              bullets: [
                'Free cancellation up to 24h before',
                '50% refund for same-day cancellation',
              ],
            },
            {
              title: 'Rules',
              bullets: [
                'No loud calls without headset',
                'Keep common areas clean',
              ],
            },
          ],
        },
        reviews_count: 48,
        working_hours: 'Sun–Thu 8AM–10PM · Fri–Sat 10AM–8PM',
        location_address: 'Al Olaya District, Riyadh',
        has_weekly_plan: true,
      },
    },
    {
      id: 'ws_002',
      data: {
        name: 'Focus Zone - Jeddah',
        subtitle: 'Quiet workspace by the sea',
        subtitleLine: '⭐ 4.6 · 5.1 km away · SAR 90/day',
        rating: 4.6,
        price_per_day: 90,
        currency: 'SAR',
        location: new admin.firestore.GeoPoint(21.4858, 39.1925),
        image_url: null,
        images: [],
        features: ['WiFi', 'Standing desks', 'Phone booths', 'Cafeteria'],
        usage_stats: [
          { label: 'Quiet level', percent: 90 },
          { label: 'WiFi speed', percent: 85 },
          { label: 'Seat availability', percent: 60 },
        ],
        why_people_come: ['Solo work', 'Video calls', 'Creative projects'],
        review_summary: {
          header: 'Perfect for solo workers',
          meta: 'Based on 31 reviews',
          top_positives: ['Peaceful environment', 'Great natural light'],
          repeated_negatives: ['Far from city center'],
          crowd_level: 'Low',
          noise: 'Very low',
        },
        latest_reviews: [
          {
            id: 'rv_3',
            user_name: 'خالد البقمي',
            time_ago: '3 days ago',
            stars: 5,
            comment: 'Perfect spot for deep work. No distractions at all.',
          },
        ],
        offers: [],
        policies: {
          title: 'Booking Policy',
          subtitle: 'Terms and conditions',
          sections: [
            {
              title: 'Cancellation',
              bullets: ['Free cancellation 48h before', 'No refund after check-in'],
            },
          ],
        },
        reviews_count: 31,
        working_hours: 'Daily 7AM–11PM',
        location_address: 'Al Hamra District, Jeddah',
        has_weekly_plan: true,
      },
    },
    {
      id: 'ws_003',
      data: {
        name: 'The Desk - Dammam',
        subtitle: 'Premium private offices',
        subtitleLine: '⭐ 4.9 · 1.8 km away · SAR 200/day',
        rating: 4.9,
        price_per_day: 200,
        currency: 'SAR',
        location: new admin.firestore.GeoPoint(26.3927, 49.9777),
        image_url: null,
        images: [],
        features: ['Private offices', '4K monitors', 'Video conferencing', 'Reception'],
        usage_stats: [
          { label: 'Quiet level', percent: 95 },
          { label: 'WiFi speed', percent: 98 },
          { label: 'Seat availability', percent: 85 },
        ],
        why_people_come: ['Client meetings', 'Team collaboration', 'Executive work'],
        review_summary: {
          header: 'Top-tier experience',
          meta: 'Based on 22 reviews',
          top_positives: ['Professional environment', 'Fast internet', 'Helpful staff'],
          repeated_negatives: ['Pricey but worth it'],
          crowd_level: 'Low',
          noise: 'Very low',
        },
        latest_reviews: [
          {
            id: 'rv_4',
            user_name: 'نورة السعد',
            time_ago: '1 day ago',
            stars: 5,
            comment: 'Absolutely worth every riyal. Best workspace I\'ve used.',
          },
        ],
        offers: [
          {
            id: 'off_2',
            badge_text: 'NEW',
            badge_type: 'new',
            title: 'Monthly Membership',
            price_line: 'SAR 3,500 / month',
            old_price_text: 'SAR 6,000',
            new_price_text: 'SAR 3,500',
            includes_text: 'Full access, unlimited printing, 5 guest passes',
            valid_until_text: 'Limited spots',
          },
        ],
        policies: {
          title: 'Booking Policy',
          subtitle: 'Important terms',
          sections: [
            {
              title: 'Cancellation',
              bullets: ['Free cancellation 72h before', '25% fee for late cancellation'],
            },
            {
              title: 'Access',
              bullets: ['ID required at reception', 'Guests must be registered'],
            },
          ],
        },
        reviews_count: 22,
        working_hours: 'Sun–Thu 6AM–12AM',
        location_address: 'Al Khobar Corniche, Dammam',
        has_weekly_plan: false,
      },
    },
  ];

  for (const ws of workspaces) {
    await db.collection('workspaces').doc(ws.id).set(ws.data);
  }
  console.log('✅ workspaces (3 documents)');

  // ────────────────────────────────────────────────────────────────────────
  // 3. BOOKINGS
  // ────────────────────────────────────────────────────────────────────────
  const now = admin.firestore.Timestamp.now();
  const daysAgo = (n) =>
    admin.firestore.Timestamp.fromDate(new Date(Date.now() - n * 86400000));
  const daysAhead = (n) =>
    admin.firestore.Timestamp.fromDate(new Date(Date.now() + n * 86400000));

  const bookings = [
    {
      id: 'bk_001',
      data: {
        user_id: USER_ID,
        space_id: 'ws_001',
        space_name: 'Masahtak Hub - Riyadh',
        date_text: 'Tomorrow, Mar 1',
        time_text: '9:00 AM – 5:00 PM',
        status: 'approved',
        total_price: 120,
        currency: 'SAR',
        image_url: null,
        created_at: daysAgo(1),
      },
    },
    {
      id: 'bk_002',
      data: {
        user_id: USER_ID,
        space_id: 'ws_002',
        space_name: 'Focus Zone - Jeddah',
        date_text: 'Sat, Feb 22',
        time_text: '10:00 AM – 3:00 PM',
        status: 'completed',
        total_price: 90,
        currency: 'SAR',
        image_url: null,
        created_at: daysAgo(5),
      },
    },
    {
      id: 'bk_003',
      data: {
        user_id: USER_ID,
        space_id: 'ws_003',
        space_name: 'The Desk - Dammam',
        date_text: 'Wed, Feb 19',
        time_text: '2:00 PM – 6:00 PM',
        status: 'rejected',
        total_price: 200,
        currency: 'SAR',
        image_url: null,
        created_at: daysAgo(8),
      },
    },
  ];

  for (const bk of bookings) {
    await db.collection('bookings').doc(bk.id).set(bk.data);
  }
  console.log('✅ bookings (3 documents)');

  // ────────────────────────────────────────────────────────────────────────
  // 4. NOTIFICATIONS
  // ────────────────────────────────────────────────────────────────────────
  const notifications = [
    {
      id: 'notif_001',
      data: {
        user_id: USER_ID,
        title: 'Booking Approved! 🎉',
        subtitle: 'Your booking at Masahtak Hub for tomorrow has been confirmed.',
        type: 'booking_approved',
        is_read: false,
        created_at: daysAgo(0),
      },
    },
    {
      id: 'notif_002',
      data: {
        user_id: USER_ID,
        title: 'Booking Reminder ⏰',
        subtitle: 'Your session at Focus Zone starts in 1 hour. Get ready!',
        type: 'reminder',
        is_read: false,
        created_at: daysAgo(0),
      },
    },
    {
      id: 'notif_003',
      data: {
        user_id: USER_ID,
        title: 'Booking Rejected',
        subtitle: 'Unfortunately, The Desk could not accept your request. Try another space.',
        type: 'booking_rejected',
        is_read: true,
        created_at: daysAgo(8),
      },
    },
    {
      id: 'notif_004',
      data: {
        user_id: USER_ID,
        title: 'New Weekly Deal 🔥',
        subtitle: 'Save 40% with the weekly pass at Masahtak Hub. Limited spots!',
        type: 'offer',
        is_read: true,
        created_at: daysAgo(10),
      },
    },
  ];

  for (const n of notifications) {
    await db.collection('notifications').doc(n.id).set(n.data);
  }
  console.log('✅ notifications (4 documents)');

  // ────────────────────────────────────────────────────────────────────────
  // 5. REVIEWS
  // ────────────────────────────────────────────────────────────────────────
  const reviews = [
    {
      id: 'rv_001',
      data: {
        user_id: USER_ID,
        space_name: 'Masahtak Hub - Riyadh',
        stars: 5,
        comment: 'Incredible space. I got so much work done here. Will definitely come back.',
        tags: ['Quiet', 'Fast WiFi', 'Comfortable'],
        created_at: daysAgo(3),
      },
    },
    {
      id: 'rv_002',
      data: {
        user_id: 'other_user_1',
        space_name: 'Focus Zone - Jeddah',
        stars: 4,
        comment: 'Great environment, a bit far but worth it.',
        tags: ['Quiet', 'Good lighting'],
        created_at: daysAgo(7),
      },
    },
    {
      id: 'rv_003',
      data: {
        user_id: 'other_user_2',
        space_name: 'The Desk - Dammam',
        stars: 5,
        comment: 'Best coworking space in Dammam, hands down.',
        tags: ['Professional', 'Fast WiFi', 'Great staff'],
        created_at: daysAgo(14),
      },
    },
    {
      id: 'rv_004',
      data: {
        user_id: 'other_user_3',
        space_name: 'Masahtak Hub - Riyadh',
        stars: 4,
        comment: 'Good space overall. Coffee could be better.',
        tags: ['Quiet', 'Convenient location'],
        created_at: daysAgo(20),
      },
    },
  ];

  for (const rv of reviews) {
    await db.collection('reviews').doc(rv.id).set(rv.data);
  }
  console.log('✅ reviews (4 documents)');

  console.log('\n🎉 Seeding complete! Open the app to see real data.');
  process.exit(0);
}

seed().catch((err) => {
  console.error('❌ Error:', err);
  process.exit(1);
});
