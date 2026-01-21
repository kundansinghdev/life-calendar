import React, { useMemo } from 'react'
import './LifeCalendarPreview.css'

export default function LifeCalendarPreview() {
    const { totalDays, dayOfYear, daysRemaining, percentageComplete, dots } = useMemo(() => {
        const now = new Date();
        const year = now.getFullYear();
        const isLeap = (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0);
        const totalDays = isLeap ? 366 : 365;

        const start = new Date(year, 0, 0);
        const diff = now - start;
        const oneDay = 1000 * 60 * 60 * 24;
        const dayOfYear = Math.floor(diff / oneDay);

        const daysRemaining = totalDays - dayOfYear;
        const percentageComplete = Math.floor((dayOfYear / totalDays) * 100);

        const dots = [];
        for (let i = 1; i <= totalDays; i++) {
            let status = 'empty';
            if (i < dayOfYear) status = 'filled';
            else if (i === dayOfYear) status = 'today';
            dots.push(status);
        }

        return { totalDays, dayOfYear, daysRemaining, percentageComplete, dots };
    }, []);

    return (
        <section className="calendar-preview">
            <div className="dot-grid">
                {dots.map((status, index) => (
                    <div key={index} className={`dot ${status}`}></div>
                ))}
            </div>

            <div className="calendar-footer">
                {daysRemaining} days remain · {percentageComplete}% complete
            </div>
        </section>
    )
}
