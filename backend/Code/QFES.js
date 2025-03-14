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

async function fetchQFES() {
    const url = `https://services1.arcgis.com/vkTwD8kHw2woKBqV/arcgis/rest/services/ESCAD_Current_Incidents_Public/FeatureServer/0/query?f=geojson&where=1%3D1&outFields=*`;

    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Error fetching from QFES: ${response.status}`);
        }
        const jsonData = await response.json();
        return jsonData;
    } catch (error) {
        console.error("Error fetching data from QFES: ", error);
        throw error;
    }
}

// Read data from a file
async function readDataFromFile(filename) {
    try {
        if (fs.existsSync(filename)) {
            const data = await fs.promises.readFile(filename, 'utf-8');
            return JSON.parse(data);
        }
        return null;
    } catch (error) {
        console.error(`Error reading data from file: ${filename}`, error);
        return null;
    }
}

// Save data to a file
async function saveDataToFile(data, filename) {
    try {
        const stringData = JSON.stringify(data, null, 2);
        await fs.promises.writeFile(filename, stringData);
    } catch (error) {
        console.error(`Error saving data to file: ${filename}`, error);
    }
}

// Find differences between existing and new data
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

// Function to parse the polygon coordinates from strings to numbers
function parsePolygon(polygon) {
    return polygon.map(coordStr => {
        const [lat, lon] = coordStr.split(',').map(Number);
        return [lat, lon];
    });
}

// Function to determine if a point is inside a polygon using the ray-casting algorithm
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

// Function to parse locality groups from a JSON file
function parseLocalityGroups(filePath) {
    try {
        const data = fs.readFileSync(filePath, 'utf-8');
        return JSON.parse(data);
    } catch (error) {
        console.error(`Error reading file ${filePath}:`, error);
        return null;
    }
}

// Function to assign locality group based on coordinates
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
          sound: 'Success',
          channel_id: 'high_importance_channel',
          priority: 'high',
          visibility: 'public',
          default_vibrate_timings: true,
          default_sound: false  // Ensure default sound is false
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'Success.wav',  // Reference the custom sound file for iOS
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
      await admin.messaging().sendMulticast(message);
      // Removed logging to minimize performance impact
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
  
async function checkAndUpdateEvents(eventsResponse, folderPath, dataPrefix) {
    const currentEventIds = new Set();
    try {
        if (eventsResponse && Array.isArray(eventsResponse.features)) {
            // Handling for QFES and TMR
            for (const feature of eventsResponse.features) {
                if (
                    (dataPrefix === 'QFES' && (feature.properties.GroupedType === 'RESCUE ROAD CRASH' || feature.properties.GroupedType === 'FIRE VEHICLE'))
                ) {
                    const id = feature.id || feature.properties.id || feature.properties.OBJECTID;
                    feature.id = id;
                    currentEventIds.add(id);

                    feature.source = dataPrefix;

                    const type = feature.properties.GroupedType || `${feature.properties.event_type} - ${feature.properties.event_subtype}`;
                    feature.event_type = type;

                    const locality = feature.properties.Locality || (feature.properties.road_summary && feature.properties.road_summary.locality.toUpperCase()) || "Unknown Locality";
                    feature.locality = locality;

                    const location = feature.properties.Location || (feature.properties.road_summary && feature.properties.road_summary.road_name) || "Unknown Location";
                    feature.location = location;

                    if (feature.properties.CurrentStatus === `Going` || feature.properties.CurrentStatus === `Contained` || feature.properties.status === `Published`) {
                        feature.status = 'Live';
                    }

                    const latitude = feature.properties.Latitude || (feature.geometry.coordinates[0][1]);
                    const longitude = feature.properties.Longitude || (feature.geometry.coordinates[0][0]);
                    
                    if (typeof latitude === 'number' && typeof longitude === 'number') {
                        feature.coordinates = new admin.firestore.GeoPoint(latitude, longitude);
                    } else {
                        console.error(`Invalid latitude or longitude for feature with id ${id}`);
                    }

                    delete feature.properties;
                    delete feature.geometry;
                    delete feature.type;

                    const localityGroups = parseLocalityGroups('C:/Users/jimme/Documents/Code/Code/localites_polygons.json');
                    feature.localityGroup = assignLocalityGroup(localityGroups, [latitude, longitude]);

                    const users = readUserFiles();
                    feature.emails = extractEmails(users, feature.localityGroup);

                    const filename = path.join(folderPath, `${dataPrefix}-${id}.json`);
                    const existingData = await readDataFromFile(filename);

                    if (!existingData) {
                        feature.time = getTimeStamp();
                        feature.unix = getUnix();
                        await saveDataToFile(feature, filename);
                        await handleNewEvent(feature);
                        console.log(`New Event - ${dataPrefix} - ${feature.id}`, getTimeStamp());

                        // Remove undefined values
                        const cleanedFeature = JSON.parse(JSON.stringify(feature, (key, value) => value === undefined ? null : value));

                        // Add to Firestore
                        await db.collection('events').doc(`${dataPrefix}-${feature.id}`).set({
                            ...cleanedFeature,
                            coordinates: feature.coordinates
                        });
                        await db.collection('history').doc(`${dataPrefix}-${feature.id}`).set({
                            ...cleanedFeature,
                            coordinates: feature.coordinates
                        });
                    } else {
                        const updatedFeature = { ...existingData, ...feature }; // Merge existing and new data
                        const differences = findDifferences(existingData, updatedFeature);
                        if (Object.keys(differences).length > 0) {
                            await saveDataToFile(updatedFeature, filename);
                            console.log(`Updated Event - ${dataPrefix} - ${feature.id}`, getTimeStamp());

                            // Remove undefined values
                            const cleanedFeature = JSON.parse(JSON.stringify(updatedFeature, (key, value) => value === undefined ? null : value));

                            // Update in Firestore
                            await db.collection('events').doc(`${dataPrefix}-${feature.id}`).set({
                                ...cleanedFeature,
                                coordinates: feature.coordinates
                            });
                            await db.collection('history').doc(`${dataPrefix}-${feature.id}`).set({
                                ...cleanedFeature,
                                coordinates: feature.coordinates
                            });
                        }
                    }
                }
            }
        } 
        await clearAbsentEvents(currentEventIds, folderPath, dataPrefix);
    } catch (error) {
        console.error(`Error in checkAndUpdateEvents: `, error);
    }
}

async function clearAbsentEvents(currentEventIds, folderPath, dataPrefix) {
    try {
        const files = fs.readdirSync(folderPath);
        for (const file of files) {
            if (file.startsWith(dataPrefix)) {
                const filePath = path.join(folderPath, file);
                const eventData = await readDataFromFile(filePath);

                if (eventData && !currentEventIds.has(eventData.id) && eventData.status !== `Cleared` && getUnix() - eventData.unix > 120) {
                    eventData.status = 'Cleared';
                    eventData.time_cleared = getTimeStamp();
                    currentEventIds.delete(eventData.id);
                    await saveDataToFile(eventData, filePath);
                    console.log(`Cleared Event - ${dataPrefix} - ${eventData.id}`, getUnix() - eventData.unix, getTimeStamp());

                    // Update Firestore
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

// Function to clear garbage collection explicitly
const forceGarbageCollection = () => {
    if (global.gc) {
        global.gc();
    } else {
        console.warn('No GC hook! Start your program with `node --expose-gc`.');
    }
};

(async () => {
    try {
        const folderPath = 'C:/Users/jimme/Documents/Code/Events';

        // Ensure folder exists
        if (!fs.existsSync(folderPath)) {
            fs.mkdirSync(folderPath);
            console.log(`Folder created: ${folderPath}`);
        }

        // QFES loop
        setInterval(async () => {
            try {
                const data = await fetchQFES();
                await checkAndUpdateEvents(data, folderPath, 'QFES');
            } catch (error) {
                console.error('Error in QFES loop:', error);
            }
        }, 2500); // 2.5 seconds interval

        // Periodic garbage collection
        setInterval(forceGarbageCollection, 60000); // Run every 1 minute

    } catch (error) {
        console.error('Error in initial setup:', error);
    }
})();
