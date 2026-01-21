import React from 'react';

const DownloadPage = () => {
    return (
        <div className="landing-page">
            <header className="site-header">Life Calendar</header>

            <div className="download-container" style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                flex: 1,
                width: '100%',
                animation: 'fadeInUp 0.8s ease-out forwards'
            }}>
                <h1 style={{
                    fontSize: '32px',
                    fontWeight: 500,
                    marginBottom: '40px',
                    letterSpacing: '-1px'
                }}>Download</h1>

                <a href="#" className="download-action-btn">
                    Download APK
                </a>

                <p style={{
                    marginTop: '24px',
                    fontSize: '14px',
                    color: '#444',
                    opacity: 0.8
                }}>
                    Thank you for supporting this idea.
                </p>
            </div>
        </div>
    );
};

export default DownloadPage;
