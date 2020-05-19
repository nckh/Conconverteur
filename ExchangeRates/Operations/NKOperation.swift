import Foundation

/// A simple operation that will be executed asynchronously in operation queues.
/// Subclasses need to call `finish()` to mark the task as completed.
public class NKOperation: Operation {

  public override var isExecuting: Bool { _isExecuting }
  public override var isFinished: Bool { _isFinished }

  private var _isExecuting = false {
    willSet {
      willChangeValue(forKey: "isExecuting")
    }
    didSet {
      didChangeValue(forKey: "isExecuting")
    }
  }

  private var _isFinished = false {
    willSet {
      willChangeValue(forKey: "isFinished")
    }
    didSet {
      didChangeValue(forKey: "isFinished")
    }
  }


  public override func start() {
    if isCancelled {
      finish()
      return
    }

    _isExecuting = true
    main()
  }

  /// Marks the task as completed.
  func finish() {
    _isExecuting = false
    _isFinished = true
  }

}
