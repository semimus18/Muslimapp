// Global variables
let currentLocation = { lat: 0, lng: 0 };
let tasbihCount = 0;
let currentDhikr = null;
let targetCount = 0;

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    getCurrentLocation();
    updateDates();
    loadIslamicEvents();
    
    // Set up geolocation watching for Qibla
    if (navigator.geolocation) {
        navigator.geolocation.watchPosition(updateLocation);
    }
}

// Navigation functions
function showTab(tabName) {
    // Hide all sections
    const sections = document.querySelectorAll('.content-section');
    sections.forEach(section => section.classList.remove('active'));
    
    // Remove active class from all nav buttons
    const navButtons = document.querySelectorAll('.nav-btn');
    navButtons.forEach(btn => btn.classList.remove('active'));
    
    // Show selected section
    document.getElementById(tabName).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

// Location and Prayer Times functions
function getCurrentLocation() {
    const locationElement = document.getElementById('current-location');
    
    if (navigator.geolocation) {
        locationElement.innerHTML = '<i class="fas fa-spinner loading"></i> Getting location...';
        
        navigator.geolocation.getCurrentPosition(
            function(position) {
                currentLocation.lat = position.coords.latitude;
                currentLocation.lng = position.coords.longitude;
                
                // Reverse geocoding to get city name (simplified)
                locationElement.textContent = `${currentLocation.lat.toFixed(2)}, ${currentLocation.lng.toFixed(2)}`;
                
                calculatePrayerTimes();
                calculateQibla();
            },
            function(error) {
                locationElement.textContent = 'Location access denied';
                // Use default location (Mecca)
                currentLocation.lat = 21.4225;
                currentLocation.lng = 39.8262;
                calculatePrayerTimes();
            }
        );
    } else {
        locationElement.textContent = 'Geolocation not supported';
        // Use default location (Mecca)
        currentLocation.lat = 21.4225;
        currentLocation.lng = 39.8262;
        calculatePrayerTimes();
    }
}

function refreshLocation() {
    getCurrentLocation();
}

function updateLocation(position) {
    currentLocation.lat = position.coords.latitude;
    currentLocation.lng = position.coords.longitude;
    calculateQibla();
}

function calculatePrayerTimes() {
    const now = new Date();
    const times = getSimplifiedPrayerTimes(currentLocation.lat, currentLocation.lng, now);
    
    document.getElementById('fajr-time').textContent = times.fajr;
    document.getElementById('dhuhr-time').textContent = times.dhuhr;
    document.getElementById('asr-time').textContent = times.asr;
    document.getElementById('maghrib-time').textContent = times.maghrib;
    document.getElementById('isha-time').textContent = times.isha;
    
    updateNextPrayer(times);
}

function getSimplifiedPrayerTimes(lat, lng, date) {
    // Simplified prayer time calculation
    // In a real app, you would use a proper prayer time calculation library
    const sunrise = new Date(date);
    sunrise.setHours(6, 0, 0, 0); // Simplified sunrise at 6 AM
    
    const sunset = new Date(date);
    sunset.setHours(18, 0, 0, 0); // Simplified sunset at 6 PM
    
    return {
        fajr: formatTime(new Date(sunrise.getTime() - 90 * 60000)), // 1.5 hours before sunrise
        dhuhr: formatTime(new Date(date.setHours(12, 0, 0, 0))), // Noon
        asr: formatTime(new Date(date.setHours(15, 30, 0, 0))), // 3:30 PM
        maghrib: formatTime(sunset), // Sunset
        isha: formatTime(new Date(sunset.getTime() + 90 * 60000)) // 1.5 hours after sunset
    };
}

function formatTime(date) {
    return date.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        hour12: true
    });
}

function updateNextPrayer(times) {
    const now = new Date();
    const prayerNames = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    const prayerTimes = [
        parseTime(times.fajr),
        parseTime(times.dhuhr),
        parseTime(times.asr),
        parseTime(times.maghrib),
        parseTime(times.isha)
    ];
    
    let nextPrayer = 'fajr';
    let nextTime = prayerTimes[0];
    
    for (let i = 0; i < prayerTimes.length; i++) {
        if (prayerTimes[i] > now) {
            nextPrayer = prayerNames[i];
            nextTime = prayerTimes[i];
            break;
        }
    }
    
    document.getElementById('next-prayer-name').textContent = nextPrayer.charAt(0).toUpperCase() + nextPrayer.slice(1);
    
    // Update countdown every second
    setInterval(() => {
        const countdown = getCountdown(nextTime);
        document.getElementById('next-prayer-countdown').textContent = countdown;
    }, 1000);
}

function parseTime(timeStr) {
    const today = new Date();
    const [time, period] = timeStr.split(' ');
    const [hours, minutes] = time.split(':').map(Number);
    
    let hour24 = hours;
    if (period === 'PM' && hours !== 12) hour24 += 12;
    if (period === 'AM' && hours === 12) hour24 = 0;
    
    const result = new Date(today);
    result.setHours(hour24, minutes, 0, 0);
    
    if (result < today) {
        result.setDate(result.getDate() + 1);
    }
    
    return result;
}

function getCountdown(targetTime) {
    const now = new Date();
    const diff = targetTime - now;
    
    if (diff <= 0) return '00:00:00';
    
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((diff % (1000 * 60)) / 1000);
    
    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

// Qibla Direction functions
function calculateQibla() {
    if (currentLocation.lat === 0 && currentLocation.lng === 0) return;
    
    const meccaLat = 21.4225;
    const meccaLng = 39.8262;
    
    const qiblaDirection = getQiblaDirection(currentLocation.lat, currentLocation.lng, meccaLat, meccaLng);
    const distance = getDistance(currentLocation.lat, currentLocation.lng, meccaLat, meccaLng);
    
    document.getElementById('qibla-degree').textContent = `${Math.round(qiblaDirection)}°`;
    document.getElementById('kaaba-distance').textContent = `${Math.round(distance)} km`;
    
    // Update compass needle
    const needle = document.getElementById('qibla-needle');
    needle.style.transform = `translate(-50%, -50%) rotate(${qiblaDirection}deg)`;
}

function getQiblaDirection(lat1, lng1, lat2, lng2) {
    const dLng = (lng2 - lng1) * Math.PI / 180;
    const lat1Rad = lat1 * Math.PI / 180;
    const lat2Rad = lat2 * Math.PI / 180;
    
    const y = Math.sin(dLng) * Math.cos(lat2Rad);
    const x = Math.cos(lat1Rad) * Math.sin(lat2Rad) - Math.sin(lat1Rad) * Math.cos(lat2Rad) * Math.cos(dLng);
    
    let bearing = Math.atan2(y, x) * 180 / Math.PI;
    return (bearing + 360) % 360;
}

function getDistance(lat1, lng1, lat2, lng2) {
    const R = 6371; // Earth's radius in kilometers
    const dLat = (lat2 - lat1) * Math.PI / 180;
    const dLng = (lng2 - lng1) * Math.PI / 180;
    
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
              Math.sin(dLng/2) * Math.sin(dLng/2);
    
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
}

function findQibla() {
    getCurrentLocation();
}

// Quran Reader functions
function loadSurah() {
    const surahSelect = document.getElementById('surah-select');
    const surahId = surahSelect.value;
    const quranText = document.getElementById('quran-text');
    
    if (!surahId) {
        quranText.innerHTML = '<p class="placeholder">Select a Surah to read</p>';
        return;
    }
    
    // Sample Quran text (in a real app, you would fetch from an API)
    const surahs = {
        '1': {
            arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ الرَّحْمَٰنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
            translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful. [All] praise is [due] to Allah, Lord of the worlds - The Entirely Merciful, the Especially Merciful, Sovereign of the Day of Recompense. It is You we worship and You we ask for help. Guide us to the straight path - The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.'
        },
        '112': {
            arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ قُلْ هُوَ اللَّهُ أَحَدٌ اللَّهُ الصَّمَدُ لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
            translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful. Say, "He is Allah, [who is] One, Allah, the Eternal Refuge. He neither begets nor is born, Nor is there to Him any equivalent."'
        }
    };
    
    const surah = surahs[surahId];
    if (surah) {
        quranText.innerHTML = `
            <div class="arabic-text">${surah.arabic}</div>
            <div class="translation">${surah.translation}</div>
        `;
    } else {
        quranText.innerHTML = '<p class="placeholder">Surah content not available</p>';
    }
}

// Tasbih Counter functions
function incrementCount() {
    tasbihCount++;
    updateCountDisplay();
    
    if (currentDhikr && tasbihCount >= targetCount) {
        completeDhikr();
    }
}

function resetCount() {
    tasbihCount = 0;
    currentDhikr = null;
    targetCount = 0;
    updateCountDisplay();
    document.getElementById('current-dhikr').innerHTML = '<span id="dhikr-text">Click count to begin</span><span id="dhikr-target"></span>';
}

function updateCountDisplay() {
    document.getElementById('tasbih-count').textContent = tasbihCount;
}

function setDhikr(dhikrText, target) {
    currentDhikr = dhikrText;
    targetCount = target;
    tasbihCount = 0;
    updateCountDisplay();
    
    document.getElementById('dhikr-text').textContent = dhikrText;
    document.getElementById('dhikr-target').textContent = `Target: ${target}`;
}

function completeDhikr() {
    alert(`Completed ${currentDhikr}! SubhanAllah!`);
    
    // Optional: Auto-reset or continue counting
    if (confirm('Would you like to start another round?')) {
        tasbihCount = 0;
        updateCountDisplay();
    }
}

// Calendar functions
function updateDates() {
    const now = new Date();
    
    // Gregorian date
    const gregorianDate = now.toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
    document.getElementById('gregorian-date').textContent = gregorianDate;
    
    // Hijri date (simplified calculation)
    const hijriDate = getHijriDate(now);
    document.getElementById('hijri-date').textContent = hijriDate;
}

function getHijriDate(gregorianDate) {
    // Simplified Hijri calculation (for demo purposes)
    // In a real app, you would use a proper Hijri calendar library
    const hijriMonths = [
        'Muharram', 'Safar', 'Rabi\' al-awwal', 'Rabi\' al-thani',
        'Jumada al-awwal', 'Jumada al-thani', 'Rajab', 'Sha\'ban',
        'Ramadan', 'Shawwal', 'Dhu al-Qi\'dah', 'Dhu al-Hijjah'
    ];
    
    // Rough approximation: subtract 622 years and adjust
    const hijriYear = gregorianDate.getFullYear() - 622;
    const hijriMonth = hijriMonths[gregorianDate.getMonth()];
    const hijriDay = gregorianDate.getDate();
    
    return `${hijriDay} ${hijriMonth} ${hijriYear} AH`;
}

function loadIslamicEvents() {
    const eventsContainer = document.getElementById('islamic-events');
    
    // Sample Islamic events (in a real app, you would fetch from an API)
    const events = [
        'Ramadan starts in approximately 45 days',
        'Eid al-Fitr in approximately 75 days',
        'Friday Prayer - Tomorrow',
        'Laylat al-Qadr (Night of Power) - During last 10 nights of Ramadan'
    ];
    
    eventsContainer.innerHTML = events.map(event => 
        `<div style="padding: 10px; border-bottom: 1px solid #e9ecef; last-child:border-bottom: none;">${event}</div>`
    ).join('');
}

// Utility functions
function vibrate() {
    if (navigator.vibrate) {
        navigator.vibrate(100);
    }
}

// Add click sound effect (optional)
function playClickSound() {
    // You can add audio feedback here if needed
    vibrate();
}

// Add event listeners for touch feedback
document.addEventListener('click', function(e) {
    if (e.target.classList.contains('count-btn')) {
        playClickSound();
    }
});

// Handle device orientation for Qibla compass
if (window.DeviceOrientationEvent) {
    window.addEventListener('deviceorientation', function(e) {
        if (e.alpha !== null) {
            const compass = e.alpha;
            // You can use this to adjust the compass direction based on device orientation
            // This would require more complex calculations for accurate Qibla direction
        }
    });
}