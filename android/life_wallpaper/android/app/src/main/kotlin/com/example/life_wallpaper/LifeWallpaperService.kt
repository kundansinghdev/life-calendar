package com.example.life_wallpaper

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.PointF
import android.graphics.Typeface
import android.os.Handler
import android.os.Looper
import android.service.wallpaper.WallpaperService
import android.view.SurfaceHolder
import java.util.Calendar

class LifeWallpaperService : WallpaperService() {
    
    companion object {
        private const val TAG = "LifeWallpaperService"
        
        // MIRRORED FROM LifeLogic.dart
        private const val GRID_TOP_RATIO = 0.12f
        private const val HORIZONTAL_MARGIN_DP = 80f
        private const val GRID_COLUMNS = 15
        private const val GRID_TO_TEXT_GAP_RATIO = 0.03f // Reduced from 0.08f
        
        private const val COLOR_ORANGE = 0xFFFFA500.toInt()
        private const val ALPHA_FUTURE = 20
    }
    
    override fun onCreateEngine(): Engine {
        return LifeEngine()
    }
    
    data class LayoutCache(
        val width: Int,
        val height: Int,
        val dotPositions: List<PointF>,
        val radius: Float,
        val gridStartY: Float,
        val gridEndY: Float,
        val dotDiameter: Float,
        val spacing: Float
    )
    
    inner class LifeEngine : Engine() {
        private var isVisible = false
        
        private val pastDayPaint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
            color = Color.WHITE
        }
        
        private val todayPaint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
            color = COLOR_ORANGE
        }
        
        private val futureDayPaint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
            color = Color.WHITE
            alpha = ALPHA_FUTURE
        }
        
        // Primary Text: "345d left"
        private val primaryTextPaint = Paint().apply {
            isAntiAlias = true
            color = Color.WHITE
            textAlign = Paint.Align.LEFT
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD) // Bold
            alpha = 76 // 0.3 opacity
            letterSpacing = 0.15f
        }
        
        // Separator: " · "
        private val separatorTextPaint = Paint().apply {
            isAntiAlias = true
            color = Color.WHITE
            textAlign = Paint.Align.LEFT
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD) // Bold
            alpha = 38 // 0.15 opacity
        }
        
        // Secondary Text: "4%"
        private val secondaryTextPaint = Paint().apply {
            isAntiAlias = true
            color = Color.WHITE
            textAlign = Paint.Align.LEFT
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD) // Bold
            alpha = 51 // 0.2 opacity
        }
        
        private var layoutCache: LayoutCache? = null
        private val handler = Handler(Looper.getMainLooper())
        
        private val updateRunnable = Runnable { 
            draw()
            scheduleUpdate()
        }

        override fun onVisibilityChanged(visible: Boolean) {
            this.isVisible = visible
            if (visible) {
                draw()
                scheduleUpdate()
            } else {
                handler.removeCallbacks(updateRunnable)
            }
        }

        override fun onSurfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
            super.onSurfaceChanged(holder, format, width, height)
            layoutCache = null
            draw()
        }

        override fun onSurfaceDestroyed(holder: SurfaceHolder) {
            super.onSurfaceDestroyed(holder)
            this.isVisible = false
            handler.removeCallbacks(updateRunnable)
        }
        
        private fun scheduleUpdate() {
            handler.removeCallbacks(updateRunnable)
            val now = Calendar.getInstance()
            val midnight = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
            }
            handler.postDelayed(updateRunnable, midnight.timeInMillis - now.timeInMillis)
        }

        private fun draw() {
            if (!isVisible) return
            val holder = surfaceHolder
            var canvas: Canvas? = null
            try {
                canvas = holder.lockCanvas()
                if (canvas != null) {
                    drawWallpaper(canvas)
                }
            } finally {
                if (canvas != null) holder.unlockCanvasAndPost(canvas)
            }
        }
        
        private fun getOrCalculateLayout(canvasWidth: Int, canvasHeight: Int, totalDays: Int): LayoutCache {
            val cached = layoutCache
            if (cached != null && cached.width == canvasWidth && cached.height == canvasHeight) return cached
            
            val gridStartY = canvasHeight * GRID_TOP_RATIO
            val availWidth = canvasWidth - (HORIZONTAL_MARGIN_DP * 2)
            val dotDiameter = availWidth / (1.5f * GRID_COLUMNS - 0.5f)
            val dotSpacing = dotDiameter * 0.5f
            val radius = dotDiameter / 2f
            
            val startX = HORIZONTAL_MARGIN_DP + radius
            
            val positions = mutableListOf<PointF>()
            var currentX = startX
            var currentY = gridStartY + radius
            var gridEndY = currentY
            
            for (i in 1..totalDays) {
                positions.add(PointF(currentX, currentY))
                gridEndY = currentY // Track last row
                if (i % GRID_COLUMNS == 0) {
                    currentX = startX
                    currentY += dotDiameter + dotSpacing
                } else {
                    currentX += dotDiameter + dotSpacing
                }
            }
            
            val screenDensity = canvasWidth / 375f
            primaryTextPaint.textSize = 14f * screenDensity
            separatorTextPaint.textSize = 14f * screenDensity
            secondaryTextPaint.textSize = 12f * screenDensity // Slightly smaller
            
            return LayoutCache(canvasWidth, canvasHeight, positions, radius, gridStartY, gridEndY, dotDiameter, dotSpacing).also { layoutCache = it }
        }

        private fun drawWallpaper(canvas: Canvas) {
            canvas.drawColor(Color.BLACK)
            val now = Calendar.getInstance()
            val year = now.get(Calendar.YEAR)
            val isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            val totalDays = if (isLeap) 366 else 365
            val dayOfYear = now.get(Calendar.DAY_OF_YEAR)
            val daysLeft = totalDays - dayOfYear
            val percentUsed = ((dayOfYear.toFloat() / totalDays.toFloat()) * 100).toInt()
            
            val layout = getOrCalculateLayout(canvas.width, canvas.height, totalDays)
            
            // 1. Draw Grid
            for (i in 0 until totalDays) {
                val dayNum = i + 1
                val paint = when {
                    dayNum < dayOfYear -> pastDayPaint
                    dayNum == dayOfYear -> todayPaint
                    else -> futureDayPaint
                }
                canvas.drawCircle(layout.dotPositions[i].x, layout.dotPositions[i].y, layout.radius, paint)
            }
            
            // 2. Draw "Fact" below grid with hierarchy
            // Text parts
            val t1 = "${daysLeft}d left"
            val tSep = " · "
            val t2 = "$percentUsed%"
            
            // Measure
            val w1 = primaryTextPaint.measureText(t1)
            val wSep = separatorTextPaint.measureText(tSep)
            val w2 = secondaryTextPaint.measureText(t2)
            
            val totalW = w1 + wSep + w2
            
            val gapHeight = canvas.height * GRID_TO_TEXT_GAP_RATIO
            val startX = (canvas.width - totalW) / 2f
            val centerY = layout.gridEndY + layout.radius + gapHeight + primaryTextPaint.textSize
            
            // Draw
            canvas.drawText(t1, startX, centerY, primaryTextPaint)
            canvas.drawText(tSep, startX + w1, centerY, separatorTextPaint)
            // Adjust baseline slightly for smaller text if needed, or keep same baseline
            canvas.drawText(t2, startX + w1 + wSep, centerY, secondaryTextPaint)
        }
    }
}
