const fetch = require('node-fetch');
const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK with your service account credentials
const serviceAccount = require('C:/Users/jimme/Documents/Code/Code/alert-app-4oeae7-firebase-adminsdk-m1qag-8fd50d3d1f.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Get a Firestore reference
const db = admin.firestore();

async function fetchWazeSeq1() {
    const url = 'https://waze-api.p.rapidapi.com/alerts?bottom-left=-27.4478,152.6675&top-right=-25.9478,153.39455&limit=500';
    const options = {
        method: 'GET',
        headers: {
            'x-rapidapi-key': '1b74ba7f3bmshd6b34bea964df9bp199d24jsn05c5745f4366',
            'x-rapidapi-host': 'waze-api.p.rapidapi.com'
        }
    };

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error fetching from new API: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData; // Returns the new array format directly
    } catch (error) {
        console.error("Error fetching data from new API: ", error);
        throw error;
    }
}

async function fetchWazeSeq2() {
    const url = 'https://waze-api.p.rapidapi.com/alerts?bottom-left=-27.4478,153.39455&top-right=-25.9478,154.1234&limit=500';
    const options = {
        method: 'GET',
        headers: {
            'x-rapidapi-key': '1b74ba7f3bmshd6b34bea964df9bp199d24jsn05c5745f4366',
            'x-rapidapi-host': 'waze-api.p.rapidapi.com'
        }
    };

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error fetching from new API: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData; // Returns the new array format directly
    } catch (error) {
        console.error("Error fetching data from new API: ", error);
        throw error;
    }
}

async function fetchWazeSeq3() {
    const url = 'https://waze-api.p.rapidapi.com/alerts?bottom-left=-28.2209,152.6675&top-right=-27.4478,153.39455&limit=500';
    const options = {
        method: 'GET',
        headers: {
            'x-rapidapi-key': '1b74ba7f3bmshd6b34bea964df9bp199d24jsn05c5745f4366',
            'x-rapidapi-host': 'waze-api.p.rapidapi.com'
        }
    };

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error fetching from new API: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData; // Returns the new array format directly
    } catch (error) {
        console.error("Error fetching data from new API: ", error);
        throw error;
    }
}

async function fetchWazeSeq4() {
    const url = 'https://waze-api.p.rapidapi.com/alerts?bottom-left=-28.2209,153.39455&top-right=-27.4478,154.1234&limit=500';
    const options = {
        method: 'GET',
        headers: {
            'x-rapidapi-key': '1b74ba7f3bmshd6b34bea964df9bp199d24jsn05c5745f4366',
            'x-rapidapi-host': 'waze-api.p.rapidapi.com'
        }
    };

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error fetching from new API: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData; // Returns the new array format directly
    } catch (error) {
        console.error("Error fetching data from new API: ", error);
        throw error;
    }
}

async function fetchWazeSeq5() {
    const url = 'https://waze-api.p.rapidapi.com/alerts?bottom-left=-28.9941,152.6675&top-right=-28.2209,153.39455&limit=500';
    const options = {
        method: 'GET',
        headers: {
            'x-rapidapi-key': '1b74ba7f3bmshd6b34bea964df9bp199d24jsn05c5745f4366',
            'x-rapidapi-host': 'waze-api.p.rapidapi.com'
        }
    };

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error fetching from new API: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData; // Returns the new array format directly
    } catch (error) {
        console.error("Error fetching data from new API: ", error);
        throw error;
    }
}

async function fetchWazeSeq6() {
    const url = 'https://waze-api.p.rapidapi.com/alerts?bottom-left=-28.9941,153.39455&top-right=-28.2209,154.1234&limit=500';
    const options = {
        method: 'GET',
        headers: {
            'x-rapidapi-key': '1b74ba7f3bmshd6b34bea964df9bp199d24jsn05c5745f4366',
            'x-rapidapi-host': 'waze-api.p.rapidapi.com'
        }
    };

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error fetching from new API: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData; // Returns the new array format directly
    } catch (error) {
        console.error("Error fetching data from new API: ", error);
        throw error;
    }
}

async function readDataFromFile(filename) {
    try {
        if (fs.existsSync(filename)) {
            const data = fs.readFileSync(filename, 'utf-8');
            return JSON.parse(data);
        }
        return null;
    } catch (error) {
        console.error(`Error reading data from file: ${filename}`, error);
        return null;
    }
}

async function saveDataToFile(data, filename) {
    try {
        const stringData = JSON.stringify(data, null, 2);
        fs.writeFileSync(filename, stringData);
    } catch (error) {
        console.error(`Error saving data to file: ${filename}`, error);
    }
}

function findDifferences(existingData, newData) {
    const differences = {};
    for (const key in newData) {
        if (existingData[key] !== newData[key]) {
            if (key === 'num_thumbs_up') {
                if (newData[key] > existingData[key]) {
                    differences[key] = {
                        oldValue: existingData[key],
                        newValue: newData[key]
                    };
                }
            } else if (typeof existingData[key] === 'object' && typeof newData[key] === 'object') {
                const nestedDifferences = findDifferences(existingData[key], newData[key]);
                if (Object.keys(nestedDifferences).length > 0) {
                    differences[key] = nestedDifferences;
                }
            } else {
                differences[key] = {
                    oldValue: existingData[key],
                    newValue: newData[key]
                };
            }
        }
    }
    return differences;
}

const getTimeStamp = () => {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    return `${hours}:${minutes}`;
}

const getUnix = () => {
    const now = new Date();
    return Math.floor(now.getTime() / 1000);
}

function parsePolygon(polygon) {
    return polygon.map(coordStr => {
        const [lat, lon] = coordStr.split(',').map(Number);
        return [lat, lon];
    });
}

function isPointInPolygon(point, polygon) {
    let x = point[0], y = point[1];
    let inside = false;

    for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
        let xi = polygon[i][0], yi = polygon[i][1];
        let xj = polygon[j][0], yj = polygon[j][1];

        let intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }

    return inside;
}

function parseLocalityGroups(filePath) {
    try {
        const data = fs.readFileSync(filePath, 'utf-8');
        return JSON.parse(data);
    } catch (error) {
        console.error(`Error reading file ${filePath}:`, error);
        return null;
    }
}

function assignLocalityGroup(localityGroups, point) {
    for (const country in localityGroups) {
        for (const state in localityGroups[country]) {
            for (const region in localityGroups[country][state]) {
                for (const subRegion in localityGroups[country][state][region]) {
                    const polygon = parsePolygon(localityGroups[country][state][region][subRegion]);
                    if (isPointInPolygon(point, polygon)) {
                        return { country, state, region, subRegion };
                    }
                }
            }
        }
    }
    return { country: "Unknown", state: "Unknown", region: "Unknown", subRegion: "Unknown" };
}

function readUserFiles() {
    const userFolderPath = 'C:/Users/jimme/Documents/Code/Users';
    try {
        const userFiles = fs.readdirSync(userFolderPath);
        const users = [];
        for (const file of userFiles) {
            const filePath = `${userFolderPath}/${file}`;
            if (filePath.endsWith('.json')) {
                const userData = JSON.parse(fs.readFileSync(filePath, 'utf-8'));
                users.push(userData);
            }
        }
        return users;
    } catch (error) {
        console.error("Error reading user files:", error);
        return [];
    }
}

function extractEmails(users, localityGroup) {
    const { country, state, region, subRegion } = localityGroup;
    const hierarchyLevels = [country, state, region, subRegion];
    const emails = [];
  
    for (const user of users) {
      if (user.areas) {
        const userAreas = user.areas.split(',').map(area => area.trim());
        if (user.subscription_status === 'active' || user.subscription_status === 'trialing') {
          for (const level of hierarchyLevels) {
            if (userAreas.includes(level)) {
              emails.push(user.email);
              break;
            }
          }
        }
      }
    }
  
    return emails;
}

async function sendNotifications(tokens, eventData) {
    const message = {
      notification: {
        title: `${eventData.source} - ${eventData.event_type}`,
        body: `${eventData.locality}${eventData.location ? ' - ' + eventData.location : ''}`
      },
      android: {
        notification: {
          sound: 'default',
          channel_id: 'high_importance_channel',
          priority: 'high',
          visibility: 'public',
          default_vibrate_timings: true,
          default_sound: true
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            alert: {
              title: `${eventData.source} - ${eventData.event_type}`,
              body: `${eventData.locality}${eventData.location ? ' - ' + eventData.location : ''}`
            }
          }
        }
      },
      tokens: tokens
    };
  
    try {
      const response = await admin.messaging().sendMulticast(message);
      // Removed logging to minimize performance impact
      // console.log('Successfully sent message:', response);
    } catch (error) {
      console.error('Error sending message:', error);
    }
}

async function handleNewEvent(eventData) {
    const localityGroup = eventData.localityGroup;
    const hierarchyLevels = [
      localityGroup.subRegion,
      localityGroup.region,
      localityGroup.state,
      localityGroup.country
    ];
  
    for (let i = 0; i < hierarchyLevels.length; i++) {
      const level = hierarchyLevels[i];
      const areaFilePath = path.join('C:/Users/jimme/Documents/Code/Areas', `${level}.json`);
  
      if (fs.existsSync(areaFilePath)) {
        const areaData = JSON.parse(fs.readFileSync(areaFilePath, 'utf-8'));
        const tokens = areaData.fcm_tokens || [];
  
        if (tokens.length > 0) {
          await sendNotifications(tokens, eventData);
        } else {
          console.log(`No FCM tokens found for locality level: ${level}`);
        }
      } else {
        console.log(`Area file not found for locality level: ${level}`);
      }
    }
}

async function checkAndUpdateEventsWaze(eventsResponse, folderPath, dataPrefix) {
    const currentEventIds = new Set();
    try {
        // Ensure response data is an array (based on new API format)
        if (Array.isArray(eventsResponse)) {
            for (const alert of eventsResponse) {

                // ✅ Filter: Only process events where event_type is "ACCIDENT"
                if (alert.type !== "ACCIDENT") {
                    continue; // Skip processing if it's not an ACCIDENT
                }

                const id = alert.id.split("/")[0]; // Extract meaningful ID
                currentEventIds.add(id);

                const processedAlert = {
                    id: id,
                    reliability: alert.reliability || 0,
                    street: alert.street || "Unknown",
                    city: alert.city || "Unknown",
                    source: dataPrefix,
                    event_type: alert.type,
                    subtype: alert.subType || "Unknown",
                    locality: alert.city ? alert.city.toUpperCase() : "UNKNOWN",
                    location: alert.street || "Unknown",
                    status: "Live",
                    unix: Math.floor(alert.timestamp / 1000), // Convert from milliseconds to seconds
                    time: new Date(alert.timestamp).toLocaleTimeString("en-AU", { hour: "2-digit", minute: "2-digit", hour12: true }),
                    coordinates: new admin.firestore.GeoPoint(alert.locationY, alert.locationX),
                    thumbs_up: alert.nThumbsUp || 0,
                    description: alert.reportDescription || "No description",
                    localityGroup: assignLocalityGroup(parseLocalityGroups('C:/Users/jimme/Documents/Code/Code/localites_polygons.json'), [alert.locationY, alert.locationX]),
                    emails: extractEmails(readUserFiles(), assignLocalityGroup(parseLocalityGroups('C:/Users/jimme/Documents/Code/Code/localites_polygons.json'), [alert.locationY, alert.locationX]))
                };

                const filename = path.join(folderPath, `${dataPrefix}-${id}.json`);
                const existingData = await readDataFromFile(filename);

                if (!existingData) {
                    await saveDataToFile(processedAlert, filename);
                    await handleNewEvent(processedAlert);
                    console.log(`New Event - ${dataPrefix} - ${processedAlert.id}`, getTimeStamp());

                    await db.collection('events').doc(`${dataPrefix}-${processedAlert.id}`).set(processedAlert);
                    await db.collection('history').doc(`${dataPrefix}-${processedAlert.id}`).set(processedAlert);
                } else {
                    const updatedAlert = { ...existingData, ...processedAlert };
                    const differences = findDifferences(existingData, updatedAlert);

                    if (Object.keys(differences).length > 0 && existingData.status !== "Cleared") {
                        await saveDataToFile(updatedAlert, filename);
                        console.log(`Updated Event - ${dataPrefix} - ${updatedAlert.id}`, getTimeStamp());

                        await db.collection('events').doc(`${dataPrefix}-${updatedAlert.id}`).set(updatedAlert);
                        await db.collection('history').doc(`${dataPrefix}-${updatedAlert.id}`).set(updatedAlert);
                    }
                }
            }
        }
        await clearAbsentEvents(currentEventIds, folderPath, dataPrefix);
    } catch (error) {
        console.error(`Error in checkAndUpdateEventsWaze: `, error);
    }
}

async function clearAbsentEvents(currentEventIds, folderPath, dataPrefix) {
    try {
        const files = fs.readdirSync(folderPath);
        for (const file of files) {
            if (file.startsWith(dataPrefix)) {
                const filePath = path.join(folderPath, file);
                const eventData = await readDataFromFile(filePath);

                if (eventData && !currentEventIds.has(eventData.id) && eventData.status !== `Cleared` && getUnix() - eventData.unix > 2700) {
                    eventData.status = 'Cleared';
                    eventData.time_cleared = getTimeStamp();
                    currentEventIds.delete(eventData.id);
                    await saveDataToFile(eventData, filePath);
                    console.log(`Cleared Event - ${dataPrefix} - ${eventData.id}`, getUnix() - eventData.unix, getTimeStamp());

                    await db.collection('history').doc(`${dataPrefix}-${eventData.id}`).set({
                        ...eventData,
                        coordinates: new admin.firestore.GeoPoint(eventData.coordinates._latitude, eventData.coordinates._longitude),
                        status: 'Cleared',
                        time_cleared: eventData.time_cleared
                    });
                    await db.collection('events').doc(`${dataPrefix}-${eventData.id}`).delete();
                }
            }
        }
    } catch (error) {
        console.error(`Error in clearAbsentEvents: `, error);
    }
}

(async () => {
    try {
        const folderPath = 'C:/Users/jimme/Documents/Code/Events';

        if (!fs.existsSync(folderPath)) {
            fs.mkdirSync(folderPath);
            console.log(`Folder created: ${folderPath}`);
        }

        setInterval(async () => {
            try {
                const data = await fetchWazeSeq1();
                await checkAndUpdateEventsWaze(data, folderPath, 'Waze');
            } catch (error) {
                console.error('Error in Waze Slow loop:', error);
            }
        }, 3000);

        setInterval(async () => {
            try {
                const data = await fetchWazeSeq2();
                await checkAndUpdateEventsWaze(data, folderPath, 'Waze');
            } catch (error) {
                console.error('Error in Waze Slow loop:', error);
            }
        }, 3000);

        setInterval(async () => {
            try {
                const data = await fetchWazeSeq3();
                await checkAndUpdateEventsWaze(data, folderPath, 'Waze');
            } catch (error) {
                console.error('Error in Waze Slow loop:', error);
            }
        }, 3000);

        setInterval(async () => {
            try {
                const data = await fetchWazeSeq4();
                await checkAndUpdateEventsWaze(data, folderPath, 'Waze');
            } catch (error) {
                console.error('Error in Waze Slow loop:', error);
            }
        }, 3000);

        setInterval(async () => {
            try {
                const data = await fetchWazeSeq5();
                await checkAndUpdateEventsWaze(data, folderPath, 'Waze');
            } catch (error) {
                console.error('Error in Waze Slow loop:', error);
            }
        }, 3000);

        setInterval(async () => {
            try {
                const data = await fetchWazeSeq6();
                await checkAndUpdateEventsWaze(data, folderPath, 'Waze');
            } catch (error) {
                console.error('Error in Waze Slow loop:', error);
            }
        }, 3000);

    } catch (error) {
        console.error('Error in initial setup:', error);
    }
})();
