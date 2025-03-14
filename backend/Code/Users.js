const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const Stripe = require('stripe');
const nodemailer = require('nodemailer');

const stripe = Stripe('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');

// Initialize Firebase Admin SDK with your service account credentials
const serviceAccount = require('C:/Users/jimme/Documents/Code/Code/alert-app-4oeae7-firebase-adminsdk-m1qag-8fd50d3d1f.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Get a Firestore reference
const db = admin.firestore();

// Create a Nodemailer transporter
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'admin@altroutetech.com',
        pass: 'xrbb ywch xftv habb'
    }
});

// Function to send an email
async function sendEmail(to, subject, text) {
    const mailOptions = {
        from: 'accounts@altroutetech.com',
        to: 'admin@altroutetech.com',
        subject,
        text
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Email sent to: ${to}`, getTimeStamp());
    } catch (error) {
        console.error('Error sending email:', getTimeStamp(), error);
    }
}

const getTimeStamp = () => {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    return `${hours}:${minutes}`;
}

// Read data from a file
async function readDataFromFile(filename) {
    try {
        if (fs.existsSync(filename)) {
            const data = fs.readFileSync(filename, 'utf-8');
            return JSON.parse(data);
        }
        return null;
    } catch (error) {
        console.error(`Error reading data from file: ${filename}`, getTimeStamp(), error);
        return null;
    }
}

// Save data to a file
async function saveDataToFile(data, filename) {
    try {
        const stringData = JSON.stringify(data, null, 2);
        fs.writeFileSync(filename, stringData);
    } catch (error) {
        console.error(`Error saving data to file: ${filename}`, getTimeStamp(), error);
    }
}

// Fetch all subscriptions with pagination
async function fetchAllSubscriptions() {
    let subscriptions = [];
    let hasMore = true;
    let startingAfter = null;

    while (hasMore) {
        const response = await stripe.subscriptions.list({
            limit: 100,
            starting_after: startingAfter || undefined,
        });

        subscriptions = subscriptions.concat(response.data);
        hasMore = response.has_more;
        if (response.data.length > 0) {
            startingAfter = response.data[response.data.length - 1].id;
        }
    }

    return subscriptions;
}

// Fetch all customers with pagination
async function fetchAllCustomers() {
    let customers = [];
    let hasMore = true;
    let startingAfter = null;

    while (hasMore) {
        const response = await stripe.customers.list({
            limit: 100,
            starting_after: startingAfter || undefined,
        });

        customers = customers.concat(response.data);
        hasMore = response.has_more;
        if (response.data.length > 0) {
            startingAfter = response.data[response.data.length - 1].id;
        }
    }

    return customers;
}

async function fetchStripeData() {
    try {
        const subscriptions = await fetchAllSubscriptions();
        const customers = await fetchAllCustomers();

        return { subscriptions, customers };
    } catch (error) {
        console.error('Error fetching data from Stripe:', getTimeStamp(), error);
        return { subscriptions: [], customers: [] };
    }
}

// Pull user information from Firestore and store it locally
async function pullUserInformation(localFolderPath) {
    try {
        const deletedUsersFolderPath = path.join(localFolderPath, 'deleted_users');

        // Ensure the local folders exist, if not create them
        if (!fs.existsSync(localFolderPath)) {
            fs.mkdirSync(localFolderPath, { recursive: true });
        }
        if (!fs.existsSync(deletedUsersFolderPath)) {
            fs.mkdirSync(deletedUsersFolderPath, { recursive: true });
        }

        const usersSnapshot = await db.collection('users').get();
        const firestoreUserIds = new Set(usersSnapshot.docs.map(doc => doc.id));
        const localUserFiles = fs.readdirSync(localFolderPath).filter(file => file.endsWith('.json'));

        for (const doc of usersSnapshot.docs) {
            const userData = doc.data();
            const uid = doc.id;

            userData.uid = uid;

            if (userData.fcmToken) {
                userData.fcmToken = userData.fcmToken;
            } else {
                userData.fcmToken = null;
            }

            const userFilePath = path.join(localFolderPath, `${uid}.json`);
            const existingUserData = await readDataFromFile(userFilePath);

            if (!existingUserData || JSON.stringify(existingUserData) !== JSON.stringify(userData)) {
                await saveDataToFile(userData, userFilePath);
                console.log(`User data saved to: ${userFilePath}`, getTimeStamp());

                if (!existingUserData) {
                    await sendEmail('admin@example.com', 'New User Detected', `A new user has been detected: 
                        \nName: ${userData.display_name}
                        \nEmail: ${userData.email}
                        \nCompany: ${userData.company}
                        \nUID: ${userData.uid}`);
                } else {
                    console.log(`User data updated: ${userFilePath}`, getTimeStamp());
                }
            }
        }

        // Move deleted user files to "deleted_users" folder
        for (const file of localUserFiles) {
            const uid = file.replace('.json', '');
            if (!firestoreUserIds.has(uid)) {
                const oldFilePath = path.join(localFolderPath, file);
                const newFilePath = path.join(deletedUsersFolderPath, file);
                fs.renameSync(oldFilePath, newFilePath);
                console.log(`Moved deleted user file to: ${newFilePath}`, getTimeStamp());
            }
        }

    } catch (error) {
        console.error('Error pulling user information:', getTimeStamp(), error);
    }
}

// Process user data and update FCM tokens in locality areas
async function processUserData(localFolderPath) {
    try {
        const userFolderPath = localFolderPath;
        const areaFolderPath = 'C:/Users/jimme/Documents/Code/Areas';
        if (!fs.existsSync(areaFolderPath)) {
            fs.mkdirSync(areaFolderPath, { recursive: true });
        }

        const userFiles = fs.readdirSync(userFolderPath).filter(file => file.endsWith('.json'));
        const userFcmTokens = new Set();

        for (const file of userFiles) {
            const filePath = path.join(userFolderPath, file);
            const userData = await readDataFromFile(filePath);

            if (userData && userData.areas && userData.fcmToken) {
                userFcmTokens.add(userData.fcmToken);
                const localityGroups = userData.areas.split(',').map(area => area.trim());

                const fcmToken = userData.fcmToken;

                for (const localityGroup of localityGroups) {
                    const areaFilePath = path.join(areaFolderPath, `${localityGroup}.json`);
                    const existingAreaData = await readDataFromFile(areaFilePath) || { fcm_tokens: [] };

                    if ((userData.subscription_status === 'active' || userData.subscription_status === 'trialing') && userData.alerts === true) {
                        if (!existingAreaData.fcm_tokens.includes(fcmToken)) {
                            existingAreaData.fcm_tokens.push(fcmToken);
                            await saveDataToFile(existingAreaData, areaFilePath);
                            console.log(`Updated area ${localityGroup} with FCM token for user ${userData.email}`, getTimeStamp());

                            await db.collection('areas').doc(localityGroup).set({
                                fcm_tokens: admin.firestore.FieldValue.arrayUnion(fcmToken)
                            }, { merge: true });
                        }
                    } else {
                        if (existingAreaData.fcm_tokens.includes(fcmToken)) {
                            existingAreaData.fcm_tokens = existingAreaData.fcm_tokens.filter(token => token !== fcmToken);
                            await saveDataToFile(existingAreaData, areaFilePath);
                            console.log(`Removed FCM token from area ${localityGroup} for user ${userData.email}`, getTimeStamp());

                            await db.collection('areas').doc(localityGroup).update({
                                fcm_tokens: admin.firestore.FieldValue.arrayRemove(fcmToken)
                            });
                        }
                    }
                }
            }
        }

        // Remove stale FCM tokens from area files and Firestore
        const areaFiles = fs.readdirSync(areaFolderPath).filter(file => file.endsWith('.json'));
        for (const areaFile of areaFiles) {
            const areaFilePath = path.join(areaFolderPath, areaFile);
            const areaData = await readDataFromFile(areaFilePath);

            if (areaData && areaData.fcm_tokens) {
                const updatedFcmTokens = areaData.fcm_tokens.filter(token => userFcmTokens.has(token));

                if (JSON.stringify(areaData.fcm_tokens) !== JSON.stringify(updatedFcmTokens)) {
                    areaData.fcm_tokens = updatedFcmTokens;
                    await saveDataToFile(areaData, areaFilePath);
                    console.log(`Removed stale FCM tokens from area file: ${areaFilePath}`, getTimeStamp());

                    await db.collection('areas').doc(areaFile.replace('.json', '')).set({
                        fcm_tokens: updatedFcmTokens
                    }, { merge: true });
                }
            }
        }
    } catch (error) {
        console.error('Error processing user data:', getTimeStamp(), error);
    }
}

// Update user subscription status
async function updateUserSubscriptionStatus(localFolderPath, stripeData) {
    try {
        const userFolderPath = localFolderPath;
        const userFiles = fs.readdirSync(userFolderPath).filter(file => file.endsWith('.json'));

        const emailToSubscriptionStatus = {};

        for (const customer of stripeData.customers) {
            const subscriptionStatus = customer.delinquent ? 'none' : 'active';
            for (const subscription of stripeData.subscriptions) {
                if (subscription.customer === customer.id) {
                    const metadataEmails = subscription.metadata?.emails?.split(',').map(email => email.trim()) || [];
                    const allEmails = new Set(metadataEmails);
                    allEmails.add(customer.email);

                    for (const email of allEmails) {
                        emailToSubscriptionStatus[email] = subscriptionStatus;
                    }
                }
            }
        }

        for (const file of userFiles) {
            const filePath = path.join(userFolderPath, file);
            const userData = await readDataFromFile(filePath);

            if (userData && userData.email) {
                const stripeSubscriptionStatus = emailToSubscriptionStatus[userData.email] || 'none';
                const existingSubscriptionStatus = userData.subscription_status || 'none';

                if (stripeSubscriptionStatus !== existingSubscriptionStatus) {
                    userData.subscription_status = stripeSubscriptionStatus;
                    await saveDataToFile(userData, filePath);
                    console.log(`Updated subscription status for user ${userData.email}`, getTimeStamp());

                    const userDocRef = db.collection('users').doc(userData.uid);
                    await userDocRef.update({
                        subscription_status: stripeSubscriptionStatus
                    });
                }
            }
        }
    } catch (error) {
        console.error('Error updating user subscription status:', getTimeStamp(), error);
    }
}

// Main function to handle pulling and processing user data and subscriptions
async function main() {
    const localUserFolderPath = 'C:/Users/jimme/Documents/Code/Users';
    const stripeData = await fetchStripeData();

    await pullUserInformation(localUserFolderPath);
    await processUserData(localUserFolderPath);
    await updateUserSubscriptionStatus(localUserFolderPath, stripeData);
}

// Run the main function every minute
setInterval(main, 5000);
