package com.example.chat

import android.graphics.Rect
import android.os.Bundle
import android.view.ViewTreeObserver
import androidx.appcompat.app.AppCompatActivity
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.litho.ComponentContext
import com.facebook.litho.LithoView
import com.facebook.soloader.SoLoader

/*
todo:
表情加载优化
标签输入框旋转后 光标没有移动
* */
class MainActivity : AppCompatActivity() {

    private var mWindowHeight = 0
    private val chatViewState = ChatViewState()


    private val mGlobalLayoutListener = ViewTreeObserver.OnGlobalLayoutListener {
        val r = Rect()
        //获取当前窗口实际的可见区域
        window.decorView.getWindowVisibleDisplayFrame(r)
        val height: Int = r.height()
        if (mWindowHeight == 0) {
            //一般情况下，这是原始的窗口高度
            mWindowHeight = height
        } else {
            if (mWindowHeight != height) {
                //两次窗口高度相减，就是软键盘高度
                val softKeyboardHeight = mWindowHeight - height
                chatViewState.onKeyboardHeightChange(softKeyboardHeight)
            } else {
                chatViewState.onKeyboardHeightChange(0)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        getWindow().getDecorView().getViewTreeObserver().addOnGlobalLayoutListener(mGlobalLayoutListener);
        Fresco.initialize(this);

        SoLoader.init(this, false)
        DisplayUtil.setContent(this)
        chatViewState.initState(this)

        val lithoView = LithoView.create(
            this,
            ChatView
                .create(ComponentContext(this))
                .propChatViewState(chatViewState)
                .build())
        setContentView(lithoView)
    }
}