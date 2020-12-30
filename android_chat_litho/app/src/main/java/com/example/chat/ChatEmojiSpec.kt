package com.example.chat


import com.example.chat4.R
import com.facebook.litho.*
import com.facebook.litho.annotations.*
import com.facebook.litho.sections.SectionContext
import com.facebook.litho.sections.common.DataDiffSection
import com.facebook.litho.sections.common.RenderEvent
import com.facebook.litho.sections.widget.PageSelectedEvent
import com.facebook.litho.sections.widget.RecyclerCollectionEventsController
import com.facebook.litho.sections.widget.ViewPagerComponent
import com.facebook.litho.widget.*
import com.facebook.yoga.YogaAlign
import com.facebook.yoga.YogaEdge
import com.facebook.yoga.YogaJustify
import com.facebook.yoga.YogaPositionType

fun emojiColum(c: ComponentContext, designWidownWidth: Int): Component {
    var colum = Column.create(c)
    for (i in 0 until 10) {
        var row = Row.create(c).justifyContent(YogaJustify.SPACE_AROUND)
        for (j in 0 until 8) {
            var index = i * 8 + j
            var text = if (index < ChatEmojiState.emojis.size)
                Text.create(c).text(ChatEmojiState.emojis[index])
                    .textSizePx(62.fitPx)
                    .clickable(true)
                    .clickHandler(ChatEmoji.onViewEvent(c, ChatEmojiSpecEvent(ChatEmojiSpecEventType.EventEmojiClick, index)))
            else
                null
            row.child(text)
        }
        colum.child(row)
    }
    var coponent = VerticalScroll.create(c)
        .widthPx(designWidownWidth - 20.fitPx)
        .heightPx(280.fitPx)
        .backgroundColor(c.getColor(R.color.colorSecond))
        .childComponent(
            colum
        )


    return coponent.build()
}


fun bigEmojiColum(c: ComponentContext, designWidownWidth: Int): Component {
    var colum = Column.create(c)
    for (i in 0 until 5) {
        var row = Row.create(c).justifyContent(YogaJustify.SPACE_AROUND)
        for (j in 0 until 4) {
            var index = i * 4 + j
            var image = if (index < ChatEmojiState.bigEmoji.size)
                Image.create(c)
                    .heightPx(120.fitPx)
                    .drawableRes(ChatEmojiState.bigEmoji[index])
                    .clickable(true)
                    .clickHandler(ChatEmoji.onViewEvent(c, ChatEmojiSpecEvent(ChatEmojiSpecEventType.EventBigEmojiClick, index)))
            else
                null
            row.child(image)
        }
        colum.child(row)
    }
    var coponent = VerticalScroll.create(c)
        .widthPx(designWidownWidth - 20.fitPx)
        .heightPx(280.fitPx)
        .backgroundColor(c.getColor(R.color.colorSecond))
        .childComponent(
            colum
        )


    return coponent.build()
}

class EmojiKind(val kind: Int)
enum class ChatEmojiSpecEventType {
    EventNone, EventEmojiClick, EventBigEmojiClick, EventEmojiKindSelect
}

class ChatEmojiSpecEvent(
    var eventTypeEmoji: ChatEmojiSpecEventType = ChatEmojiSpecEventType.EventNone,
    var intParam: Int = 0,
    var stringParam: String = ""
)

class ChatEmojiSpecState {
    var emojiSelect = 0
}

var emojikinds = arrayOf(EmojiKind(0), EmojiKind(1))

@LayoutSpec
object ChatEmojiSpec {

    @OnCreateInitialState
    fun onCreateInitialState(
        c: ComponentContext,
        chatViewState: StateValue<ChatViewState>,
        chatEmojiSpecState: StateValue<ChatEmojiSpecState>,
        eventsController: StateValue<RecyclerCollectionEventsController>,
        @Prop propChatViewState: ChatViewState,
    ) {
        chatViewState.set(propChatViewState)
        chatEmojiSpecState.set(ChatEmojiSpecState())
        val recyclerCollectionEventsController = RecyclerCollectionEventsController()
        eventsController.set(recyclerCollectionEventsController)
    }

    @OnCreateLayout
    fun onCreateLayout(
        c: ComponentContext,
        @State chatViewState: ChatViewState,
        @State chatEmojiSpecState: ChatEmojiSpecState,
        @State eventsController: RecyclerCollectionEventsController,
    ): Component {
        return if (chatViewState.showEmoji) {
            Column.create(c)
                .heightPx(chatViewState.emojiHeight - 40.fitPx)
                .marginPx(YogaEdge.ALL, 10.fitPx)
                .marginPx(YogaEdge.BOTTOM, 30.fitPx)
                .child(
                    Row.create(c)
                        .flexGrow(1f)
                        .child(
                            ViewPagerComponent.create<Any>(c)
                                .positionPx(YogaEdge.ALL, 0)
                                .dataDiffSection(
                                    DataDiffSection.create<EmojiKind>(SectionContext(c))
                                        .data(emojikinds.toList())
                                        .renderEventHandler(ChatEmoji.onRenderEvent(c))
                                        .build())
                                .eventsController(eventsController)
                                .pageSelectedEventHandler(ChatEmoji.onPageEvent(c))
                        )
                )
                .child(
                    Row.create(c)
                        .heightPx(80.fitPx)
                        .alignItems(YogaAlign.CENTER)
                        .child(
                            SolidColor.create(c)
                                .positionType(YogaPositionType.ABSOLUTE)
                                .color(c.getColor(R.color.colorSecond))
                                .widthPx(68.fitPx)
                                .heightPx(80.fitPx)
                                .positionPx(YogaEdge.START, if (chatEmojiSpecState.emojiSelect == 0) 0 else 78.fitPx)
                        )
                        .child(
                            Row.create(c)
                                .heightPx(68.fitPx)
                                .widthPx(68.fitPx)
                                .marginPx(YogaEdge.RIGHT, 10.fitPx)
                                .clickable(true)
                                .clickHandler(ChatEmoji.onViewEvent(c, ChatEmojiSpecEvent(ChatEmojiSpecEventType.EventEmojiKindSelect, 0)))
                                .child(Text.create(c).text(ChatEmojiState.emojis[0]).textSizePx(52.fitPx))
                        )
                        .child(
                            Image.create(c)
                                .heightPx(68.fitPx)
                                .widthPx(68.fitPx)
                                .marginPx(YogaEdge.RIGHT, 10.fitPx)
                                .drawableRes(R.drawable.expression_01)
                                .clickable(true)
                                .clickHandler(ChatEmoji.onViewEvent(c, ChatEmojiSpecEvent(ChatEmojiSpecEventType.EventEmojiKindSelect, 1)))
                        )
                ).build()
        } else {
            Column.create(c).build()
        }
    }

    @OnUpdateState
    fun updateChatEmoji() {

    }

    @OnEvent(RenderEvent::class)
    fun onRenderEvent(c: ComponentContext, @State chatViewState: ChatViewState, @FromEvent model: EmojiKind): RenderInfo? {
        val componentinfo = if (model.kind == 0)
            emojiColum(c, chatViewState.designWidownWidth)
        else
            bigEmojiColum(c, chatViewState.designWidownWidth)

        return ComponentRenderInfo.create()
            .component(componentinfo)
            .build()
    }

    @OnEvent(PageSelectedEvent::class)
    fun onPageEvent(
        c: ComponentContext?,
        @FromEvent selectedPageIndex: Int,
        @State chatEmojiSpecState: ChatEmojiSpecState,
    ) {
        chatEmojiSpecState.emojiSelect = selectedPageIndex
        ChatEmoji.updateChatEmoji(c)

    }

    @OnEvent(ClickEvent::class)
    fun onViewEvent(c: ComponentContext, @State chatViewState: ChatViewState, @State chatEmojiSpecState: ChatEmojiSpecState, @State eventsController: RecyclerCollectionEventsController, @Param eventEmoji: ChatEmojiSpecEvent) {
        if (eventEmoji.eventTypeEmoji == ChatEmojiSpecEventType.EventEmojiClick) {
            var emojiIndex = eventEmoji.intParam
            chatViewState.onInputEmoji(ChatEmojiState.emojis[emojiIndex])
        }
        if (eventEmoji.eventTypeEmoji == ChatEmojiSpecEventType.EventBigEmojiClick) {
            var emojiIndex = eventEmoji.intParam
            chatViewState.onInputBigEmoji(emojiIndex)
        }
        if (eventEmoji.eventTypeEmoji == ChatEmojiSpecEventType.EventEmojiKindSelect) {
            var emojiIndex = eventEmoji.intParam
            chatEmojiSpecState.emojiSelect = emojiIndex
            ChatEmoji.updateChatEmoji(c)
            if (emojiIndex == 0) {
                eventsController.requestScrollToPreviousPosition(true)
            } else {
                eventsController.requestScrollToNextPosition(true)
            }

        }
    }
}
