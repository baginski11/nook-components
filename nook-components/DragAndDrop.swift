import SwiftUI
import AppKit

struct DragAndDrop: View {
    var body: some View {
        DragAndDropRepresentable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DragAndDropRepresentable: NSViewRepresentable {
    func makeNSView(context: Context) -> DragAndDropView {
        DragAndDropView()
    }
    
    func updateNSView(_ nsView: DragAndDropView, context: Context) {}
}

class DragAndDropView: NSView {
    private var items: [ItemModel] = [
        ItemModel(text: "1", icon: "globe"),
        ItemModel(text: "2", icon: "globe"),
        ItemModel(text: "3", icon: "globe"),
        ItemModel(text: "4", icon: "globe"),
    ]
    
    private var draggedIndex: Int?
    private var draggedView: DraggableItemView?
    private var stackView: NSStackView!
    private var dropIndicators: [NSView] = []
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor
        
        stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        reloadItems()
        registerForDraggedTypes([.string])
    }
    
    private func reloadItems() {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        dropIndicators.removeAll()
        
        for (index, item) in items.enumerated() {
            let indicator = createDropIndicator()
            stackView.addArrangedSubview(indicator)
            dropIndicators.append(indicator)
            
            let itemView = createItemView(item: item, index: index)
            stackView.addArrangedSubview(itemView)
        }
        
        let finalIndicator = createDropIndicator()
        stackView.addArrangedSubview(finalIndicator)
        dropIndicators.append(finalIndicator)
    }
    
    private func createDropIndicator() -> NSView {
        let indicator = NSView()
        indicator.wantsLayer = true
        indicator.layer?.backgroundColor = NSColor.white.cgColor
        indicator.isHidden = true
        
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 300),
            indicator.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        return indicator
    }
    
    private func createItemView(item: ItemModel, index: Int) -> DraggableItemView {
        let itemView = DraggableItemView(item: item, index: index)
        itemView.onDragStart = { [weak self] idx, view in
            self?.draggedIndex = idx
            self?.draggedView = view
        }
        return itemView
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        updateDropIndicator(at: sender.draggingLocation)
        return .move
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        updateDropIndicator(at: sender.draggingLocation)
        return .move
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        hideAllIndicators()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let draggedIndex = draggedIndex,
              let draggedView = draggedView else { return false }
        
        let dropIndex = calculateDropIndex(at: sender.draggingLocation)
        
        hideAllIndicators()
        
        let adjustedDropIndex = dropIndex > draggedIndex ? dropIndex - 1 : dropIndex
        
        if draggedIndex != adjustedDropIndex {
            let item = items.remove(at: draggedIndex)
            items.insert(item, at: adjustedDropIndex)
            
            let targetPosition = adjustedDropIndex * 2 + 1
            
            let currentDragFrame = NSRect(
                x: sender.draggingLocation.x - 150,
                y: sender.draggingLocation.y - 22,
                width: 300,
                height: 44
            )
            
            let snapshotView = NSImageView(image: draggedView.createSnapshot())
            snapshotView.wantsLayer = true
            snapshotView.imageScaling = .scaleNone
            snapshotView.frame = convert(currentDragFrame, from: nil)
            snapshotView.layer?.opacity = 0.7
            addSubview(snapshotView)
            
            draggedView.isHidden = true
            
            stackView.removeArrangedSubview(draggedView)
            stackView.insertArrangedSubview(draggedView, at: targetPosition)
            stackView.layoutSubtreeIfNeeded()
            
            let targetFrame = convert(draggedView.frame, from: stackView)
            
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                
                snapshotView.animator().frame = targetFrame
                snapshotView.animator().alphaValue = 1.0
            } completionHandler: {
                snapshotView.removeFromSuperview()
                draggedView.isHidden = false
                draggedView.layer?.opacity = 1.0
                
                let itemViews = self.stackView.arrangedSubviews.filter { $0 is DraggableItemView } as! [DraggableItemView]
                for (index, view) in itemViews.enumerated() {
                    view.updateIndex(index)
                }
            }
        } else {
            draggedView.layer?.opacity = 1.0
        }
        
        self.draggedIndex = nil
        self.draggedView = nil
        return true
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        draggedView?.layer?.opacity = 1.0
        draggedView?.isHidden = false
        self.draggedIndex = nil
        self.draggedView = nil
    }
    
    private func updateDropIndicator(at location: NSPoint) {
        let dropIndex = calculateDropIndex(at: location)
        hideAllIndicators()
        
        if dropIndex < dropIndicators.count {
            dropIndicators[dropIndex].isHidden = false
        }
    }
    
    private func calculateDropIndex(at location: NSPoint) -> Int {
        let point = convert(location, from: nil)
        let itemViews = stackView.arrangedSubviews.filter { $0 is DraggableItemView }
        
        for (index, view) in itemViews.enumerated() {
            let frame = convert(view.frame, from: stackView)
            let midY = frame.midY
            
            if point.y > midY {
                return index
            }
        }
        
        return itemViews.count
    }
    
    private func hideAllIndicators() {
        dropIndicators.forEach { $0.isHidden = true }
    }
}

class DraggableItemView: NSView, NSDraggingSource {
    private let item: ItemModel
    private var currentIndex: Int
    private var mouseDownLocation: NSPoint?
    var onDragStart: ((Int, DraggableItemView) -> Void)?
    
    init(item: ItemModel, index: Int) {
        self.item = item
        self.currentIndex = index
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateIndex(_ newIndex: Int) {
        currentIndex = newIndex
    }
    
    private func setupUI() {
        wantsLayer = true
        layer?.cornerRadius = 12
        layer?.backgroundColor = NSColor.white.cgColor
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 300),
            heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let hStack = NSStackView()
        hStack.orientation = .horizontal
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        let imageView = NSImageView()
        imageView.image = NSImage(systemSymbolName: item.icon, accessibilityDescription: nil)
        imageView.contentTintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        hStack.addArrangedSubview(imageView)
        
        let label = NSTextField(labelWithString: item.text)
        label.font = NSFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        hStack.addArrangedSubview(label)
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseDownLocation = event.locationInWindow
        super.mouseDown(with: event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let mouseDownLocation = mouseDownLocation else { return }
        
        let currentLocation = event.locationInWindow
        let dragDistance = hypot(
            currentLocation.x - mouseDownLocation.x,
            currentLocation.y - mouseDownLocation.y
        )
        
        guard dragDistance >= 3 else { return }
        
        self.mouseDownLocation = nil
        
        onDragStart?(currentIndex, self)
        
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(String(currentIndex), forType: .string)
        
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        
        let snapshot = createSnapshot()
        
        let draggingFrame = NSRect(x: 0, y: 0, width: 300, height: 44)
        draggingItem.setDraggingFrame(draggingFrame, contents: snapshot)
        
        layer?.opacity = 0.3
        
        let session = beginDraggingSession(with: [draggingItem], event: event, source: self)
        session.animatesToStartingPositionsOnCancelOrFail = true
        session.draggingFormation = .none
        
    }
    
    func createSnapshot() -> NSImage {
        let image = NSImage(size: NSSize(width: 300, height: 44))
        image.lockFocus()
        
        if let context = NSGraphicsContext.current?.cgContext {
            context.saveGState()
            context.setAlpha(0.7)
            
            if let layer = self.layer {
                layer.render(in: context)
            }
            
            context.restoreGState()
        }
        
        image.unlockFocus()
        return image
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        .move
    }
    
    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        layer?.opacity = 1.0
    }
}

struct ItemModel: Identifiable {
    let id: UUID
    var text: String
    var icon: String
    
    init(text: String, icon: String) {
        self.id = UUID()
        self.text = text
        self.icon = icon
    }
}

#Preview {
    DragAndDrop()
        .frame(width: 300, height: 300)
}
