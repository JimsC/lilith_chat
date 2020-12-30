package com.example.chat

import android.content.Context
import java.text.Format
import java.text.SimpleDateFormat
import java.util.*

/**
 * dp、sp 转换为 px 的工具类
 *
 *
 */
inline val Int.fitPx: Int get() = DisplayUtil.coverPix(this)

//获取当前日期
fun Date.getToday(): String {
//需要得到的格式
    val sdf: Format = SimpleDateFormat("yyyy-MM-dd")
    return sdf.format(this)
}

object DisplayUtil {
    var desiginWidth = 720 //设计尺寸的像素
    var desiginHeight = 1080

    var windowWidthPix = 720 //真实尺寸 像素
    var windowHeightPix = 1280

    var context: Context? = null

    fun setWindowSize(widht: Int, height: Int) {
        windowHeightPix = height
        windowWidthPix = widht
    }

    fun setContent(outcontext: Context) {
        val dm = outcontext.resources.displayMetrics
        setWindowSize(dm.widthPixels, dm.heightPixels)
        context = outcontext
    }

    fun coverPix(showpix: Int):Int {
        return windowWidthPix*showpix/desiginWidth
    }

    /**
     * 将px值转换为dip或dp值，保证尺寸大小不变
     */
    fun px2dip(context: Context, pxValue: Float): Float {
        val scale = context.resources.displayMetrics.density
        return pxValue / scale + 0.5f
    }

    /**
     * 将dip或dp值转换为px值，保证尺寸大小不变
     */
    fun dip2px(context: Context, dipValue: Float): Int {
        val scale = context.resources.displayMetrics.density
        return (dipValue * scale + 0.5f).toInt()
    }

    /**
     * 将px值转换为sp值，保证文字大小不变
     */
    fun px2sp(context: Context, pxValue: Float): Int {
        val fontScale = context.resources.displayMetrics.scaledDensity
        return (pxValue / fontScale + 0.5f).toInt()
    }

    /**
     * 将sp值转换为px值，保证文字大小不变
     */
    fun sp2px(context: Context, spValue: Float): Int {
        val fontScale = context.resources.displayMetrics.scaledDensity
        return (spValue * fontScale + 0.5f).toInt()
    }
}