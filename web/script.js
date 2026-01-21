document.addEventListener('DOMContentLoaded', () => {
    initCalendar();
    initModal();
    updateLockScreenTime();
});

function initCalendar() {
    const grid = document.getElementById('dotGrid');
    const now = new Date();
    const year = now.getFullYear();
    const isLeap = (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
    const totalDays = isLeap ? 366 : 365;
    
    // Calculate Day of Year
    const start = new Date(year, 0, 0);
    const diff = now - start;
    const oneDay = 1000 * 60 * 60 * 24;
    const dayOfYear = Math.floor(diff / oneDay);

    // Update Stats
    const daysLeft = totalDays - dayOfYear;
    const percentLeft = Math.floor((dayOfYear / totalDays) * 100);
    
    document.getElementById('daysLeft').textContent = daysLeft;
    document.getElementById('percentLeft').textContent = percentLeft;

    // Render Grid
    grid.innerHTML = '';
    // Optimal columns for 365 dots to fit ratio usually ~13-15 cols
    // 13 cols x 28 rows = 364. Close enough for visual representation?
    // User asked for "one dot equals one day". We must be exact.
    // CSS Grid can handle auto flow.
    
    for (let i = 1; i <= totalDays; i++) {
        const dot = document.createElement('div');
        dot.classList.add('dot');
        
        if (i < dayOfYear) {
            dot.classList.add('filled');
        } else if (i === dayOfYear) {
            dot.classList.add('today');
        }
        
        grid.appendChild(dot);
    }
}

function updateLockScreenTime() {
    const timeEl = document.getElementById('lockTime');
    const dateEl = document.getElementById('lockDate');
    
    const now = new Date();
    
    // Time
    let hours = now.getHours();
    const minutes = now.getMinutes().toString().padStart(2, '0');
    // const ampm = hours >= 12 ? 'PM' : 'AM'; // Minimalist often uses 12h or 24h depending on locale.
    // Visual shows "8:00", so 12h format without AM/PM common on lock screens or just large numbers.
    // Let's stick to 24h or simple 12h.
    // Actually, prompt says "8:00".
    
    // Let's do 12h no suffix for elegance
    hours = hours % 12;
    hours = hours ? hours : 12; 
    timeEl.textContent = `${hours}:${minutes}`;

    // Date
    const options = { weekday: 'short', month: 'short', day: 'numeric' };
    dateEl.textContent = now.toLocaleDateString('en-US', options);
}

function initModal() {
    const modal = document.getElementById('installModal');
    const btn = document.getElementById('installBtn');
    const close = document.querySelector('.close-modal');
    
    btn.addEventListener('click', () => {
        modal.classList.add('active');
    });
    
    close.addEventListener('click', () => {
        modal.classList.remove('active');
    });
    
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.classList.remove('active');
        }
    });
}
