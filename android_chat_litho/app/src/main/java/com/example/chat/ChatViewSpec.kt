package com.example.chat

import android.annotation.SuppressLint
import android.graphics.Color
import android.graphics.Outline
import android.text.InputFilter
import android.text.InputType
import android.view.View
import android.view.ViewOutlineProvider
import android.view.animation.LinearInterpolator
import android.widget.ImageView
import com.example.chat4.R
import com.facebook.common.internal.ImmutableList
import com.facebook.drawee.backends.pipeline.Fresco
import com.facebook.drawee.generic.RoundingParams
import com.facebook.imagepipeline.request.ImageRequest
import com.facebook.litho.*
import com.facebook.litho.animation.AnimatedProperties
import com.facebook.litho.annotations.*
import com.facebook.litho.fresco.FrescoImage
import com.facebook.litho.sections.Children
import com.facebook.litho.sections.SectionContext
import com.facebook.litho.sections.annotations.GroupSectionSpec
import com.facebook.litho.sections.annotations.OnCreateChildren
import com.facebook.litho.sections.common.DataDiffSection
import com.facebook.litho.sections.common.OnCheckIsSameContentEvent
import com.facebook.litho.sections.common.OnCheckIsSameItemEvent
import com.facebook.litho.sections.common.RenderEvent
import com.facebook.litho.sections.widget.RecyclerCollectionComponent
import com.facebook.litho.sections.widget.RecyclerCollectionEventsController
import com.facebook.litho.widget.*
import com.facebook.yoga.YogaAlign
import com.facebook.yoga.YogaEdge
import com.facebook.yoga.YogaJustify
import com.facebook.yoga.YogaPositionType

val headids = intArrayOf(R.drawable.head1, R.drawable.head2, R.drawable.head3, R.drawable.head4)
var selectColors = arrayListOf(
    Color.rgb(6, 1, 0),
    Color.rgb(54, 50, 39),
    Color.rgb(152, 143, 134),
    Color.rgb(242, 233, 224),
)

var unselectColors = arrayListOf(
    Color.rgb(255, 252, 252),
    Color.rgb(230, 218, 206),
    Color.rgb(164, 150, 123),
    Color.rgb(99, 81, 57),
)

@SuppressLint("ResourceType")
fun senderTile(c: SectionContext?, headid: Int): Component.Builder<*>? {
    val index = headid % headids.size
    val path = "res:/" + headids[index]

    return Row.create(c)
        .marginPx(YogaEdge.ALL, 4.fitPx)
        .widthPx(100.fitPx)
        .heightPx(100.fitPx)
        .flexShrink(0f)
        .alignItems(YogaAlign.CENTER)
        .justifyContent(YogaJustify.CENTER)
        .child(
            FrescoImage.create(c)
                .roundingParams(RoundingParams.asCircle())
                .controller(
                    Fresco.newDraweeControllerBuilder()
                        .setImageRequest(ImageRequest.fromUri(path))
                        .build())
                .widthPx(84.fitPx)
                .heightPx(84.fitPx)
        )
}

fun senderContent(c: SectionContext?, chatMessage: ChatMessage): Component.Builder<*>? {

    return Column.create(c)
        .paddingPx(YogaEdge.ALL, 4.fitPx)
        .transitionKey("CHAT_CONTENT")
        .transitionKeyType(Transition.TransitionKeyType.GLOBAL)
        .child(
            if (chatMessage.isSelf()) {
                null
            } else {
                Text.create(c)
                    .paddingPx(YogaEdge.ALL, 4.fitPx)
                    .textSizePx(20.fitPx).textColor(Color.argb(255, 105, 99, 87)).text(chatMessage.mSendNick)
            }

        )
        .child(
            if (chatMessage.mContents.mType == ChatMessage.MsgType.EMOJI) {
                senderContentEmoji(c, chatMessage)
            } else {
                senderContentText(c, chatMessage)
            }
        )
        .child(
            senderTransStatus(c, chatMessage)
        )

}

fun copyBtn(c: SectionContext?, chatMessage: ChatMessage): Component.Builder<*>? {
    return if (chatMessage.stateSelect) {
        Row.create(c)
            .positionType(YogaPositionType.ABSOLUTE)
            .widthPercent(100f)
            .widthPx(40.fitPx)
            .justifyContent(YogaJustify.CENTER)
            .child(
                Text.create(c)
                    .flexGrow(0f)
                    .marginPx(YogaEdge.ALL, 4.fitPx)
                    .paddingPx(YogaEdge.LEFT, 6.fitPx)
                    .paddingPx(YogaEdge.RIGHT, 6.fitPx)
                    .paddingPx(YogaEdge.TOP, 2.fitPx)
                    .paddingPx(YogaEdge.BOTTOM, 2.fitPx)
                    .backgroundColor(Color.rgb(50, 50, 50))
                    .clipToOutline(true)
                    .outlineProvider(
                        object : ViewOutlineProvider() {
                            override fun getOutline(view: View, outline: Outline) {
                                outline.setRoundRect(0, 0, view.width, view.height, 12f)
                            }
                        }
                    )
                    .text("复制")
                    .textColor(Color.WHITE)
                    .clickable(true)
                    .clickHandler(ChatContentSection.onCopyEvent(c))
            )
    } else {
        null
    }
}

fun senderContentEmoji(c: SectionContext?, chatMessage: ChatMessage): Component.Builder<*>? {
    var emojiIndex = chatMessage.mContents.mContent.toInt()
    return if (emojiIndex >= 0 && emojiIndex < ChatEmojiState.bigEmoji.size) {
        Image.create(c)
            .widthPx(300.fitPx)
            .drawableRes(ChatEmojiState.bigEmoji[emojiIndex])
    } else {
        null
    }
}

fun senderContentText(c: SectionContext?, chatMessage: ChatMessage): Component.Builder<*>? {
    return Row.create(c)
        .paddingPx(YogaEdge.ALL, 12.fitPx)
        .backgroundColor(Color.argb(255, 249, 241, 230))
        .clipToOutline(true)
        .outlineProvider(
            object : ViewOutlineProvider() {
                override fun getOutline(view: View, outline: Outline) {
                    outline.setRoundRect(0, 0, view.width, view.height, 12f)
                }
            }
        )
        .child(
            if (chatMessage.isSelf() || chatMessage.mMsgState == ChatMessage.MsgState.UNTRANS
                || chatMessage.mMsgState == ChatMessage.MsgState.TRANSING) {
                Text.create(c).textSizePx(24.fitPx)
                    .textColor(Color.argb(255, 105, 99, 87))
                    .text(chatMessage.mContents.mContent)
                    .longClickHandler(ChatContentSection.onMsgLongClickEvent(c, chatMessage.mID))
            } else {
                Column.create(c)
                    .child(
                        Text.create(c).textSizePx(24.fitPx)
                            .textColor(Color.argb(255, 105, 99, 87))
                            .text(chatMessage.mContents.mContent)
                            .longClickHandler(ChatContentSection.onMsgLongClickEvent(c, chatMessage.mID))
                    )
                    .child(
                        Column.create(c).heightPx(1.fitPx).backgroundColor(Color.BLACK)
                    )
                    .child(
                        Text.create(c).textSizePx(24.fitPx)
                            .textColor(Color.argb(255, 105, 99, 87))
                            .text(chatMessage.mTransContents.mContent)
                            .longClickHandler(ChatContentSection.onMsgLongClickEvent(c, chatMessage.mID))
                    )
            }
        )


}

fun senderTransStatus(c: SectionContext?, chatMessage: ChatMessage): Component.Builder<*>? {
    val statustext = if (chatMessage.mMsgState == ChatMessage.MsgState.TRANSED)
        "已翻译"
    else if (chatMessage.mMsgState == ChatMessage.MsgState.TRANSING)
        "翻译中"
    else
        ""
    return if (chatMessage.mMsgState == ChatMessage.MsgState.TRANSED || chatMessage.mMsgState == ChatMessage.MsgState.TRANSING) {
        Row.create(c)
            .child(
                Text.create(c)
                    .flexGrow(0f)
                    .marginPx(YogaEdge.ALL, 4.fitPx)
                    .paddingPx(YogaEdge.LEFT, 6.fitPx)
                    .paddingPx(YogaEdge.RIGHT, 6.fitPx)
                    .paddingPx(YogaEdge.TOP, 2.fitPx)
                    .paddingPx(YogaEdge.BOTTOM, 2.fitPx)
                    .backgroundColor(Color.rgb(50, 50, 50))
                    .clipToOutline(true)
                    .outlineProvider(
                        object : ViewOutlineProvider() {
                            override fun getOutline(view: View, outline: Outline) {
                                outline.setRoundRect(0, 0, view.width, view.height, 12f)
                            }
                        }
                    )
                    .text(statustext)
                    .textColor(Color.WHITE)
                    .textSizePx(16.fitPx)
            )

    } else {
        null
    }
}

@SuppressLint("ResourceType")
fun senderTransIcon(c: SectionContext?, chatMessage: ChatMessage): Component.Builder<*>? {
    return if (chatMessage.mMsgState == ChatMessage.MsgState.TRANSED) {
        null
    } else {
        Image.create(c)
            .marginPx(YogaEdge.ALL, 10.fitPx)
            .alignSelf(YogaAlign.FLEX_END)
            .widthPx(40.fitPx)
            .heightPx(40.fitPx)
            .flexShrink(0f)
            .drawableRes(R.drawable.ic_trans)
            .clickable(true)
            .clickHandler(ChatContentSection.onTransEvent(c, chatMessage.mID))
    }

}

fun menuPage(c: ComponentContext?, chatViewState: ChatViewState): Component.Builder<*>? {
    var colum = Column.create(c)
        .minWidthPx(400.fitPx)
        .minHeightPx(chatViewState.designWidownHeight)
        .alignItems(YogaAlign.CENTER)
        .paddingPx(YogaEdge.LEFT, 10.fitPx)
        .paddingPx(YogaEdge.RIGHT, 10.fitPx)
        .transitionKey("MENU_ANIM")
        .child(
            Text.create(c)
                .heightPx(62.fitPx)
                .text("消息")
                .textSizePx(36.fitPx)
                .textColor(Color.argb(255, 239, 227, 193))
        )
    for (item in chatViewState.chatChannels) {
        colum.child(
            menuItem(c, item)
        )
    }

    return if (chatViewState.showMenu) colum else null
}

fun menuItem(c: ComponentContext?, chatChannel: ChatChannel): Component.Builder<*>? {
    val path = "res:/" + R.drawable.head1
    var colors = if (chatChannel.isSelect) selectColors else unselectColors
    return Row.create(c)
        .widthPercent(100f)
        .backgroundColor(colors[3])
        .marginPx(YogaEdge.TOP, 10.fitPx)
        .alignItems(YogaAlign.CENTER)

        .clipToOutline(true)
        .outlineProvider(
            object : ViewOutlineProvider() {
                override fun getOutline(view: View, outline: Outline) {
                    outline.setRoundRect(0, 0, view.width, view.height, 12f)
                }
            }
        )
        .child(
            FrescoImage.create(c)
                .roundingParams(RoundingParams.asCircle())
                .controller(
                    Fresco.newDraweeControllerBuilder()
                        .setImageRequest(ImageRequest.fromUri(path))
                        .build())
                .widthPx(84.fitPx)
                .heightPx(84.fitPx)
                .marginPx(YogaEdge.RIGHT, 20.fitPx)
                .marginPx(YogaEdge.LEFT, 20.fitPx)
        )
        .child(Column.create(c)
            .flexGrow(1f)
            .justifyContent(YogaJustify.SPACE_BETWEEN)
            .paddingPx(YogaEdge.ALL, 4.fitPx)
            .child(Text.create(c).text(chatChannel.channelName).textSizePx(38.fitPx).textColor(colors[0]))
            .child(Text.create(c).text(chatChannel.lastMsg).textSizePx(26.fitPx).textColor(colors[1]))
            .child(Text.create(c).text(chatChannel.lastTime).textSizePx(18.fitPx).textColor(colors[2]))
        )
        .clickable(true)
        .clickHandler(ChatView.onViewEvent(c, ChatViewSpecEvent(ChatViewSpecEventType.EventChannel, chatChannel.channelIndex)))
}

fun mainTitle(c: ComponentContext, showMenu: Boolean): Component.Builder<*>? {
    val drawres = if (showMenu) R.drawable.ic_hidemenu else R.drawable.ic_showmenu

    return Row.create(c)
        .heightPx(62.fitPx)
        .widthPercent(100f)
        .justifyContent(YogaJustify.SPACE_BETWEEN)
        .alignItems(YogaAlign.CENTER)
        .paddingPx(YogaEdge.LEFT, 10.fitPx)
        .paddingPx(YogaEdge.RIGHT, 10.fitPx)
        .child(
            Image.create(c)
                .paddingPx(YogaEdge.ALL, 4.fitPx)
                .widthPx(48.fitPx)
                .heightPx(48.fitPx)
                .drawableRes(drawres)
                //.foregroundColor(c.getColor(R.color.colorSecond))
                .scaleType(ImageView.ScaleType.CENTER_CROP)
                .clickHandler(ChatView.onViewEvent(c, ChatViewSpecEvent(ChatViewSpecEventType.EventMenu)))
                .build() //
        )
        .child(
            Text.create(c)
                .paddingPx(YogaEdge.ALL, 4.fitPx)
                .text("中文简体")
                .textSizePx(40.fitPx)
                .textColor(Color.argb(255, 239, 227, 193))

        )
        .child(
            Text.create(c)
                .widthPx(80.fitPx)
                .paddingPx(YogaEdge.ALL, 4.fitPx)
                .text("Add")
                .textSizePx(40.fitPx)
                .clickable(true)
                .clickHandler(ChatView.onViewEvent(c, ChatViewSpecEvent(ChatViewSpecEventType.EventTestAdd)))
        )

}

fun mainInputRow(c: ComponentContext, chatViewState: ChatViewState, textInputHandle: Handle): Component.Builder<*>? {
    return Row.create(c)
        .heightPx(100.fitPx)
        .marginPx(YogaEdge.LEFT, 16.fitPx)
        .marginPx(YogaEdge.RIGHT, 16.fitPx)
        .alignItems(YogaAlign.CENTER)
        .child(
            Image.create(c)
                .flexShrink(0f)
                //.marginPx(YogaEdge.ALL, 4.fitPx)
                .widthPx(58.fitPx)
                .heightPx(58.fitPx)
                .drawableRes(R.drawable.ic_emoji)
                //.foregroundColor(c.getColor(R.color.colorSecond))
                .scaleType(ImageView.ScaleType.CENTER_CROP)
                .clickable(true)
                .clickHandler(ChatView.onViewEvent(c, ChatViewSpecEvent(ChatViewSpecEventType.EventEmoji)))
                .build())
        .child(

            TextInput.create(c)
                .flexGrow(1f)
                .heightPx(68.fitPx)
                .marginPx(YogaEdge.LEFT, 10.fitPx)
                .marginPx(YogaEdge.RIGHT, 10.fitPx)

                .paddingPx(YogaEdge.TOP, 0)
                .paddingPx(YogaEdge.BOTTOM, 0)
                .textSizePx(28.fitPx)
                .inputType(InputType.TYPE_CLASS_TEXT)
                .initialText("")
                .inputFilter(InputFilter.LengthFilter(100))
                .multiline(false)
                .handle(textInputHandle)
                .focusable(!chatViewState.showMenu)
                .textChangedEventHandler(ChatView.onInputChange(c))


                .backgroundColor(Color.WHITE)
                .clipToOutline(true)
                .outlineProvider(
                    object : ViewOutlineProvider() {
                        override fun getOutline(view: View, outline: Outline) {
                            outline.setRoundRect(0, 0, view.width, view.height, 12f)
                        }
                    }
                )
        )
        .child(
            Row.create(c)
                .flexShrink(0f)
                //.marginPx(YogaEdge.ALL, 4.fitPx)
                .widthPx(120.fitPx)
                .heightPx(68.fitPx)
                //.background(getMessageBackground(c, -0xff7b01))
                .backgroundColor(-0xff7b01)
                .clipToOutline(true)
                .outlineProvider(
                    object : ViewOutlineProvider() {
                        override fun getOutline(view: View, outline: Outline) {
                            outline.setRoundRect(0, 0, view.width, view.height, 12f)
                        }
                    }
                )
                .justifyContent(YogaJustify.CENTER)
                .alignItems(YogaAlign.CENTER)
                .child(
                    Text.create(c)
                        //.alignSelf(YogaAlign.CENTER)
                        .text("发送")
                        .textSizePx(34.fitPx)
                        .textColor(Color.argb(255, 255, 255, 255))
                        .build()
                )
                .clickable(true)
                .clickHandler(ChatView.onViewEvent(c, ChatViewSpecEvent(ChatViewSpecEventType.EventTextSend)))
        )

}


enum class ChatViewSpecEventType {
    EventNone, EventMenu, EventTestAdd, EventEmoji, EventTextSend, EventTextChange,
    EventChannel, EventTranslate, EventEmojiClick, EventBigEmojiClick, EventRefresh
}

class ChatViewSpecEvent(
    var eventTypeChat: ChatViewSpecEventType = ChatViewSpecEventType.EventNone,
    var intParam: Int = 0,
    var stringParam: String = ""
)

class ChatViewSpecState {
    var eventsController: RecyclerCollectionEventsController = RecyclerCollectionEventsController()
    var textInputHandle: Handle = Handle()
    var emojiSelect = 0
}

@LayoutSpec
object ChatViewSpec {
    private const val ANIMATION_DURATION = 100

    private val ANIMATOR = Transition.timing(ANIMATION_DURATION, LinearInterpolator())

    @OnCreateInitialState
    fun onCreateInitialState(
        c: ComponentContext,
        chatViewState: StateValue<ChatViewState>,
        chatViewSpecState: StateValue<ChatViewSpecState>,
        @Prop propChatViewState: ChatViewState,
    ) {
        val viewSpecState = ChatViewSpecState()
        propChatViewState.viewUpdater = {
            ChatView.updateChatView(c)
        }
        propChatViewState.viewKeyboardChange = {
            if (it) {
                TextInput.requestFocus(c, viewSpecState.textInputHandle)
            }
        }
        propChatViewState.viewScroller = {
            viewSpecState.eventsController.requestScrollToPosition(propChatViewState.chatMsgs.size - 1, it)
        }
        propChatViewState.viewInputChange = {
            TextInput.setText(c, viewSpecState.textInputHandle, propChatViewState.inputText)
        }

        chatViewState.set(propChatViewState)
        chatViewSpecState.set(viewSpecState)
    }

    @OnCreateLayout
    fun onCreateLayout(
        c: ComponentContext,
        @State chatViewState: ChatViewState,
        @State chatViewSpecState: ChatViewSpecState,
    ): Component {
        val contentHeight = if (chatViewState.keyboardHeight > 0)
            chatViewState.designWidownHeight - chatViewState.keyboardHeight
        else
            chatViewState.designWidownHeight

        return Row.create(c)
            .backgroundColor(c.getColor(R.color.colorPrimary))
            .child(menuPage(c, chatViewState))
            .child(Column
                .create(c)
                .flexShrink(0f)
                .widthPx(chatViewState.designWidownWidth)
                .heightPx(contentHeight)
                .transitionKey("MAIN_PAGE")
                .child(mainTitle(c, chatViewState.showMenu))
                .child(
                    RecyclerCollectionComponent.create(c)
                        .flexGrow(1F)
                        .marginPx(YogaEdge.ALL, 10.fitPx)
                        .backgroundColor(c.getColor(R.color.colorSecond))
                        //.recyclerConfiguration(GridRecyclerConfiguration.create().numColumns(10).build())
                        .disablePTR(false)
                        .section(
                            ChatContentSection.create(SectionContext(c))
                                .dataModel(ImmutableList.copyOf(chatViewState.chatMsgs))
                                .transClickEventHandler(ChatView.onNewTransClickEvent(c))
                                .longPressMsgEventHandler(ChatView.onLongPressMsgEvent(c))
                                .copyMsgEventHandler(ChatView.onCopyMsgEvent(c))
                        )
                        .refreshProgressBarBackgroundColorRes(R.color.colorPrimary)
                        .refreshProgressBarColorRes(R.color.colorSecond)
                        .pTRRefreshEventHandler(ChatView.onRefresh(c))
                        .ignoreLoadingUpdates(true)

                        .eventsController(chatViewSpecState.eventsController)
                        .build()

                ).child(Column.create(c)
                    .widthPx(chatViewState.designWidownWidth)
                    .child(mainInputRow(c, chatViewState, chatViewSpecState.textInputHandle))
                    //.child(createMainEmojiRow(c, chatViewState, chatViewSpecState))
                    .child(ChatEmoji.create(c).propChatViewState(chatViewState))
                )
            )

            .build()
    }

    @OnCreateTransition
    fun onCreateTransition(c: ComponentContext?): Transition? {

        //return Transition.allLayout().animator(ANIMATOR);
        return Transition.parallel(

            Transition.create(
                Transition.TransitionKeyType.LOCAL, "MENU_ANIM")
                .animator(ANIMATOR)
                .animate(AnimatedProperties.WIDTH)
                .appearFrom(0f)
                .animate(AnimatedProperties.WIDTH)
                .disappearTo(0f)
                .animate(AnimatedProperties.ALPHA)
                .appearFrom(0f)
                .animate(AnimatedProperties.ALPHA)
                .disappearTo(0f),


            Transition.create(
                Transition.TransitionKeyType.LOCAL, "MAIN_PAGE")
                .animator(ANIMATOR)
                //.timing(ANIMATION_DURATION, LinearInterpolator())
                .animate(AnimatedProperties.X)
                .appearFrom(0f)
                .disappearTo(0f),

            Transition.create(
                Transition.TransitionKeyType.GLOBAL, "CHAT_CONTENT")
                .animate(AnimatedProperties.HEIGHT)
                .appearFrom(0f)
                .disappearTo(0f),
        )
    }

    @OnUpdateState
    fun updateChatView() {

    }

    @OnEvent(TextChangedEvent::class)
    fun onInputChange(c: ComponentContext, @State chatViewState: ChatViewState, @FromEvent text: String) {
        chatViewState.onInputChange(text)
    }

    @OnEvent(TransClickEvent::class)
    fun onNewTransClickEvent(
        c: ComponentContext,
        @State chatViewState: ChatViewState,
        @FromEvent msgid: Int,
    ) {
        chatViewState.onTransMsg(msgid)
    }

    @OnEvent(LongPressMsgEvent::class)
    fun onLongPressMsgEvent(
        c: ComponentContext,
        @State chatViewState: ChatViewState,
        @FromEvent msgid: Int,
    ) {
        chatViewState.onLongPressMsg(msgid)
    }

    @OnEvent(CopyMsgEvent::class)
    fun onCopyMsgEvent(
        c: ComponentContext,
        @State chatViewState: ChatViewState,
        @FromEvent msgid: Int,
    ) {
        chatViewState.onCopyMsg()
    }

    @OnEvent(PTRRefreshEvent::class)
    fun onRefresh(c: ComponentContext, @State chatViewState: ChatViewState, @State chatViewSpecState: ChatViewSpecState): Boolean {
        chatViewState.refreshMsg() {
            chatViewSpecState.eventsController.clearRefreshing()
            chatViewSpecState.eventsController.requestScrollToTop(true)
        }
        return false
    }

    @OnEvent(ClickEvent::class)
    fun onViewEvent(
        c: ComponentContext, @State chatViewState: ChatViewState, @State chatViewSpecState: ChatViewSpecState, @Param eventChat: ChatViewSpecEvent) {

        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventTextSend) {
            chatViewState.onSendInput()
            TextInput.setText(c, chatViewSpecState.textInputHandle, "")
        }
        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventMenu) {
            chatViewState.onMenuClick()
        }
        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventChannel) {
            chatViewState.onChannelChange(eventChat.intParam)
        }
        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventTestAdd) {
            chatViewState.addCurrentMsg()
        }
        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventEmoji) {
            chatViewState.onEmojiClick()
        }
        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventEmojiClick) {
            var emojiIndex = eventChat.intParam
            chatViewState.onInputAdd(ChatEmojiState.emojis[emojiIndex])
            TextInput.setText(c, chatViewSpecState.textInputHandle, chatViewState.inputText)
        }
        if (eventChat.eventTypeChat == ChatViewSpecEventType.EventBigEmojiClick) {
            var emojiIndex = eventChat.intParam
            chatViewState.onInputBigEmoji(emojiIndex)
        }
    }


}

@Event
class TransClickEvent {
    @JvmField
    var msgid = 0
}

@Event
class CopyMsgEvent {
    @JvmField
    var msgid = 0
}

@Event
class LongPressMsgEvent {
    @JvmField
    var msgid = 0
}

class ChatContentSectionSpecState {
    var longPressMsgid = -1
    var lastPressMsgid = -1
}

@GroupSectionSpec(events = [TransClickEvent::class, CopyMsgEvent::class, LongPressMsgEvent::class])
object ChatContentSectionSpec {
    @OnCreateInitialState
    fun onCreateInitialState(
        c: SectionContext,
        chatContentSectionSpecState: StateValue<ChatContentSectionSpecState>
    ) {
        chatContentSectionSpecState.set(ChatContentSectionSpecState())
    }

    @OnCreateChildren
    fun onCreateChildren(
        c: SectionContext?,
        @State chatContentSectionSpecState: ChatContentSectionSpecState,
        @Prop dataModel: ImmutableList<ChatMessage>?): Children {
        return Children.create()
            .child(DataDiffSection.create<Any>(c)
                .data(dataModel)
                .renderEventHandler(ChatContentSection.onRender(c))
                .onCheckIsSameItemEventHandler(ChatContentSection.onCheckIsSameItem(c))
                .onCheckIsSameContentEventHandler(ChatContentSection.onCheckIsSameContent(c))
            )
            .build()
    }

    @OnEvent(RenderEvent::class)
    fun onRender(
        c: SectionContext?,
        @State chatContentSectionSpecState: ChatContentSectionSpecState,
        @FromEvent model: ChatMessage): RenderInfo {
        var component = if (model.isSelf()) {
            Row.create(c)
                .widthPercent(100.0f)
                .paddingPx(YogaEdge.TOP, 10.fitPx)
                .justifyContent(YogaJustify.FLEX_END)
                .child(Column.create(c).maxWidthPx((720 - 220).fitPx)
                    .child(senderContent(c, model))
                    .child(copyBtn(c, model))
                )
                .child(senderTile(c, model.mSenderHeader))
                .clickable(true)
                .clickHandler(ChatContentSection.onMsgClickEvent(c))
                .build()
        } else {
            Row.create(c)
                .widthPercent(100.0f)
                .paddingPx(YogaEdge.TOP, 10.fitPx)
                .child(senderTile(c, model.mSenderHeader))
                .child(Column.create(c).maxWidthPx((720 - 220).fitPx)
                    .child(senderContent(c, model))
                    .child(copyBtn(c, model))
                )
                .child(senderTransIcon(c, model))
                .clickable(true)
                .clickHandler(ChatContentSection.onMsgClickEvent(c))
                .build()
        }

        return ComponentRenderInfo.create().component(component).build()

    }

    @OnEvent(OnCheckIsSameItemEvent::class)
    fun onCheckIsSameItem(
        c: SectionContext?,
        @FromEvent previousItem: ChatMessage,
        @FromEvent nextItem: ChatMessage): Boolean {
        return previousItem.mID == nextItem.mID
    }

    @OnEvent(OnCheckIsSameContentEvent::class)
    fun onCheckIsSameContent(
        c: SectionContext?,
        @State chatContentSectionSpecState: ChatContentSectionSpecState,
        @FromEvent previousItem: ChatMessage?,
        @FromEvent nextItem: ChatMessage?): Boolean {
        if (previousItem != null) {
            if (nextItem != null) {
                return previousItem.mMsgState == nextItem.mMsgState && previousItem.stateSelect == nextItem.stateSelect
            }
        }
        return false
    }


    @OnEvent(ClickEvent::class)
    fun onTransEvent(c: SectionContext, @Param msgid: Int) {
        ChatContentSection.dispatchTransClickEvent(ChatContentSection.getTransClickEventHandler(c), msgid)
    }

    @OnEvent(ClickEvent::class)
    fun onCopyEvent(c: SectionContext, ) {
        ChatContentSection.dispatchCopyMsgEvent(ChatContentSection.getCopyMsgEventHandler(c), 0)
    }

    @OnEvent(ClickEvent::class)
    fun onMsgClickEvent(c: SectionContext, ) {
        ChatContentSection.dispatchLongPressMsgEvent(ChatContentSection.getLongPressMsgEventHandler(c), -1)
    }

    @OnEvent(LongClickEvent::class)
    fun onMsgLongClickEvent(c: SectionContext, @Param msgid: Int): Boolean {
        ChatContentSection.dispatchLongPressMsgEvent(ChatContentSection.getLongPressMsgEventHandler(c), msgid)
        return true
    }

    @OnUpdateState
    fun updateChatView() {

    }
}