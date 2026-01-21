import React, { useState, useEffect } from 'react'
import appLauncherImage from './app-launcher.png'
import DownloadPage from './components/DownloadPage'

function App() {
    const [path, setPath] = useState(window.location.pathname);

    useEffect(() => {
        const handlePopState = () => setPath(window.location.pathname);
        window.addEventListener('popstate', handlePopState);
        return () => window.removeEventListener('popstate', handlePopState);
    }, []);

    if (path === '/download') {
        return <DownloadPage />;
    }

    const handleInstall = () => {
        window.location.href = "https://rzp.io/rzp/EWagTTUv";
    };

    return (
        <div className="landing-page">
            <header className="site-header">Life Calendar</header>
            <section className="hero-section">
                <h1>Minimalist wallpapers<br />for mindful living.</h1>
                <p>Visualize your life progress or year at a glance.<br />Updated automatically on your lock screen.</p>

                <div className="showcase-container">
                    <img src={appLauncherImage} alt="Year Calendar Preview" className="showcase-image" />
                </div>

                <button className="install-button" onClick={handleInstall}>
                    <span>Install</span>
                    <svg width="12" height="12" viewBox="0 0 12 12" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M4.5 9L7.5 6L4.5 3" stroke="white" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                </button>
            </section>
            <footer className="site-footer">
                <p>Made by @kundansingh</p>
            </footer>
        </div>
    )
}

export default App
