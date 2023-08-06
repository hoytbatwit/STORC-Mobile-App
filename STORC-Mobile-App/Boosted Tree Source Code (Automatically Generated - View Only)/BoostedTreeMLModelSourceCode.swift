


//MARK: PLEASE NOTE THAT THIS FILE IS NOT CURRENTLY IN USE. IT IS COMMENTED OUT AS IT ONLY SERVES AS A LOOK INTO THE CREATEML SOURCE CODE THAT POWERS THE BOOSTED TREE ML MODEL. THE ML MODEL USED IN OUR CODE IS REFERENCED IN THE 'STORCTabularClassifier Boosted Tree' FILE AND THAT IS WHAT IS USED FOR OUR PREDICTIONS. SEE THE 'ContractionMonitoringDriver.swift' CLASS TO SEE HOW IT IS USED. THANK YOU!

////
//// STORCTabularClassifier_Boosted_Tree.swift
////
//// This file was automatically generated and should not be edited.
////
//
//import CoreML
//
//
///// Model Prediction Input Type
//@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
//class STORCTabularClassifier_Boosted_TreeInput : MLFeatureProvider {
//
//    /// HR 0.00 as double value
//    var HR_0_00: Double
//
//    /// HR - 0.05 as double value
//    var HR___0_05: Double
//
//    /// HR - 0.10 as double value
//    var HR___0_10: Double
//
//    /// HR - 0.15 as double value
//    var HR___0_15: Double
//
//    /// HR - 0.20 as double value
//    var HR___0_20: Double
//
//    /// HR - 0.25 as double value
//    var HR___0_25: Double
//
//    /// HR - 0.30 as double value
//    var HR___0_30: Double
//
//    /// HR - 0.35 as double value
//    var HR___0_35: Double
//
//    /// HR - 0.40 as double value
//    var HR___0_40: Double
//
//    /// HR - 0.45 as double value
//    var HR___0_45: Double
//
//    /// HR - 0.50 as double value
//    var HR___0_50: Double
//
//    /// HR - 0.55 as double value
//    var HR___0_55: Double
//
//    /// HR - 1.0 as double value
//    var HR___1_0: Double
//
//    /// HR 1.05 as double value
//    var HR_1_05: Double
//
//    /// HR - 1.10 as double value
//    var HR___1_10: Double
//
//    /// HR - 1.15 as double value
//    var HR___1_15: Double
//
//    /// HR - 1.20 as double value
//    var HR___1_20: Double
//
//    /// HR - 1.25 as double value
//    var HR___1_25: Double
//
//    /// HR - 1.30 as double value
//    var HR___1_30: Double
//
//    var featureNames: Set<String> {
//        get {
//            return ["HR 0.00", "HR - 0.05", "HR - 0.10", "HR - 0.15", "HR - 0.20", "HR - 0.25", "HR - 0.30", "HR - 0.35", "HR - 0.40", "HR - 0.45", "HR - 0.50", "HR - 0.55", "HR - 1.0", "HR 1.05", "HR - 1.10", "HR - 1.15", "HR - 1.20", "HR - 1.25", "HR - 1.30"]
//        }
//    }
//
//    func featureValue(for featureName: String) -> MLFeatureValue? {
//        if (featureName == "HR 0.00") {
//            return MLFeatureValue(double: HR_0_00)
//        }
//        if (featureName == "HR - 0.05") {
//            return MLFeatureValue(double: HR___0_05)
//        }
//        if (featureName == "HR - 0.10") {
//            return MLFeatureValue(double: HR___0_10)
//        }
//        if (featureName == "HR - 0.15") {
//            return MLFeatureValue(double: HR___0_15)
//        }
//        if (featureName == "HR - 0.20") {
//            return MLFeatureValue(double: HR___0_20)
//        }
//        if (featureName == "HR - 0.25") {
//            return MLFeatureValue(double: HR___0_25)
//        }
//        if (featureName == "HR - 0.30") {
//            return MLFeatureValue(double: HR___0_30)
//        }
//        if (featureName == "HR - 0.35") {
//            return MLFeatureValue(double: HR___0_35)
//        }
//        if (featureName == "HR - 0.40") {
//            return MLFeatureValue(double: HR___0_40)
//        }
//        if (featureName == "HR - 0.45") {
//            return MLFeatureValue(double: HR___0_45)
//        }
//        if (featureName == "HR - 0.50") {
//            return MLFeatureValue(double: HR___0_50)
//        }
//        if (featureName == "HR - 0.55") {
//            return MLFeatureValue(double: HR___0_55)
//        }
//        if (featureName == "HR - 1.0") {
//            return MLFeatureValue(double: HR___1_0)
//        }
//        if (featureName == "HR 1.05") {
//            return MLFeatureValue(double: HR_1_05)
//        }
//        if (featureName == "HR - 1.10") {
//            return MLFeatureValue(double: HR___1_10)
//        }
//        if (featureName == "HR - 1.15") {
//            return MLFeatureValue(double: HR___1_15)
//        }
//        if (featureName == "HR - 1.20") {
//            return MLFeatureValue(double: HR___1_20)
//        }
//        if (featureName == "HR - 1.25") {
//            return MLFeatureValue(double: HR___1_25)
//        }
//        if (featureName == "HR - 1.30") {
//            return MLFeatureValue(double: HR___1_30)
//        }
//        return nil
//    }
//
//    init(HR_0_00: Double, HR___0_05: Double, HR___0_10: Double, HR___0_15: Double, HR___0_20: Double, HR___0_25: Double, HR___0_30: Double, HR___0_35: Double, HR___0_40: Double, HR___0_45: Double, HR___0_50: Double, HR___0_55: Double, HR___1_0: Double, HR_1_05: Double, HR___1_10: Double, HR___1_15: Double, HR___1_20: Double, HR___1_25: Double, HR___1_30: Double) {
//        self.HR_0_00 = HR_0_00
//        self.HR___0_05 = HR___0_05
//        self.HR___0_10 = HR___0_10
//        self.HR___0_15 = HR___0_15
//        self.HR___0_20 = HR___0_20
//        self.HR___0_25 = HR___0_25
//        self.HR___0_30 = HR___0_30
//        self.HR___0_35 = HR___0_35
//        self.HR___0_40 = HR___0_40
//        self.HR___0_45 = HR___0_45
//        self.HR___0_50 = HR___0_50
//        self.HR___0_55 = HR___0_55
//        self.HR___1_0 = HR___1_0
//        self.HR_1_05 = HR_1_05
//        self.HR___1_10 = HR___1_10
//        self.HR___1_15 = HR___1_15
//        self.HR___1_20 = HR___1_20
//        self.HR___1_25 = HR___1_25
//        self.HR___1_30 = HR___1_30
//    }
//
//}
//
//
///// Model Prediction Output Type
//@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
//class STORCTabularClassifier_Boosted_TreeOutput : MLFeatureProvider {
//
//    /// Source provided by CoreML
//    private let provider : MLFeatureProvider
//
//    /// State as string value
//    var State: String {
//        return self.provider.featureValue(for: "State")!.stringValue
//    }
//
//    /// StateProbability as dictionary of strings to doubles
//    var StateProbability: [String : Double] {
//        return self.provider.featureValue(for: "StateProbability")!.dictionaryValue as! [String : Double]
//    }
//
//    var featureNames: Set<String> {
//        return self.provider.featureNames
//    }
//
//    func featureValue(for featureName: String) -> MLFeatureValue? {
//        return self.provider.featureValue(for: featureName)
//    }
//
//    init(State: String, StateProbability: [String : Double]) {
//        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["State" : MLFeatureValue(string: State), "StateProbability" : MLFeatureValue(dictionary: StateProbability as [AnyHashable : NSNumber])])
//    }
//
//    init(features: MLFeatureProvider) {
//        self.provider = features
//    }
//}
//
//
///// Class for model loading and prediction
//@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
//class STORCTabularClassifier_Boosted_Tree {
//    let model: MLModel
//
//    /// URL of model assuming it was installed in the same bundle as this class
//    class var urlOfModelInThisBundle : URL {
//        let bundle = Bundle(for: self)
//        return bundle.url(forResource: "STORCTabularClassifier Boosted Tree", withExtension:"mlmodelc")!
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance with an existing MLModel object.
//
//        Usually the application does not use this initializer unless it makes a subclass of STORCTabularClassifier_Boosted_Tree.
//        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `STORCTabularClassifier_Boosted_Tree.urlOfModelInThisBundle` to create a MLModel object to pass-in.
//
//        - parameters:
//          - model: MLModel object
//    */
//    init(model: MLModel) {
//        self.model = model
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance by automatically loading the model from the app's bundle.
//    */
//    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
//    convenience init() {
//        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
//    }
//
//    /**
//        Construct a model with configuration
//
//        - parameters:
//           - configuration: the desired model configuration
//
//        - throws: an NSError object that describes the problem
//    */
//    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
//    convenience init(configuration: MLModelConfiguration) throws {
//        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance with explicit path to mlmodelc file
//        - parameters:
//           - modelURL: the file url of the model
//
//        - throws: an NSError object that describes the problem
//    */
//    convenience init(contentsOf modelURL: URL) throws {
//        try self.init(model: MLModel(contentsOf: modelURL))
//    }
//
//    /**
//        Construct a model with URL of the .mlmodelc directory and configuration
//
//        - parameters:
//           - modelURL: the file url of the model
//           - configuration: the desired model configuration
//
//        - throws: an NSError object that describes the problem
//    */
//    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
//    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
//        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance asynchronously with optional configuration.
//
//        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
//
//        - parameters:
//          - configuration: the desired model configuration
//          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
//    */
//    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
//    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<STORCTabularClassifier_Boosted_Tree, Error>) -> Void) {
//        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance asynchronously with optional configuration.
//
//        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
//
//        - parameters:
//          - configuration: the desired model configuration
//    */
//    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
//    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> STORCTabularClassifier_Boosted_Tree {
//        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance asynchronously with URL of the .mlmodelc directory with optional configuration.
//
//        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
//
//        - parameters:
//          - modelURL: the URL to the model
//          - configuration: the desired model configuration
//          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
//    */
//    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
//    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<STORCTabularClassifier_Boosted_Tree, Error>) -> Void) {
//        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
//            switch result {
//            case .failure(let error):
//                handler(.failure(error))
//            case .success(let model):
//                handler(.success(STORCTabularClassifier_Boosted_Tree(model: model)))
//            }
//        }
//    }
//
//    /**
//        Construct STORCTabularClassifier_Boosted_Tree instance asynchronously with URL of the .mlmodelc directory with optional configuration.
//
//        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
//
//        - parameters:
//          - modelURL: the URL to the model
//          - configuration: the desired model configuration
//    */
//    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
//    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> STORCTabularClassifier_Boosted_Tree {
//        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
//        return STORCTabularClassifier_Boosted_Tree(model: model)
//    }
//
//    /**
//        Make a prediction using the structured interface
//
//        - parameters:
//           - input: the input to the prediction as STORCTabularClassifier_Boosted_TreeInput
//
//        - throws: an NSError object that describes the problem
//
//        - returns: the result of the prediction as STORCTabularClassifier_Boosted_TreeOutput
//    */
//    func prediction(input: STORCTabularClassifier_Boosted_TreeInput) throws -> STORCTabularClassifier_Boosted_TreeOutput {
//        return try self.prediction(input: input, options: MLPredictionOptions())
//    }
//
//    /**
//        Make a prediction using the structured interface
//
//        - parameters:
//           - input: the input to the prediction as STORCTabularClassifier_Boosted_TreeInput
//           - options: prediction options
//
//        - throws: an NSError object that describes the problem
//
//        - returns: the result of the prediction as STORCTabularClassifier_Boosted_TreeOutput
//    */
//    func prediction(input: STORCTabularClassifier_Boosted_TreeInput, options: MLPredictionOptions) throws -> STORCTabularClassifier_Boosted_TreeOutput {
//        let outFeatures = try model.prediction(from: input, options:options)
//        return STORCTabularClassifier_Boosted_TreeOutput(features: outFeatures)
//    }
//
//    /**
//        Make a prediction using the convenience interface
//
//        - parameters:
//            - HR_0_00 as double value
//            - HR___0_05 as double value
//            - HR___0_10 as double value
//            - HR___0_15 as double value
//            - HR___0_20 as double value
//            - HR___0_25 as double value
//            - HR___0_30 as double value
//            - HR___0_35 as double value
//            - HR___0_40 as double value
//            - HR___0_45 as double value
//            - HR___0_50 as double value
//            - HR___0_55 as double value
//            - HR___1_0 as double value
//            - HR_1_05 as double value
//            - HR___1_10 as double value
//            - HR___1_15 as double value
//            - HR___1_20 as double value
//            - HR___1_25 as double value
//            - HR___1_30 as double value
//
//        - throws: an NSError object that describes the problem
//
//        - returns: the result of the prediction as STORCTabularClassifier_Boosted_TreeOutput
//    */
//    func prediction(HR_0_00: Double, HR___0_05: Double, HR___0_10: Double, HR___0_15: Double, HR___0_20: Double, HR___0_25: Double, HR___0_30: Double, HR___0_35: Double, HR___0_40: Double, HR___0_45: Double, HR___0_50: Double, HR___0_55: Double, HR___1_0: Double, HR_1_05: Double, HR___1_10: Double, HR___1_15: Double, HR___1_20: Double, HR___1_25: Double, HR___1_30: Double) throws -> STORCTabularClassifier_Boosted_TreeOutput {
//        let input_ = STORCTabularClassifier_Boosted_TreeInput(HR_0_00: HR_0_00, HR___0_05: HR___0_05, HR___0_10: HR___0_10, HR___0_15: HR___0_15, HR___0_20: HR___0_20, HR___0_25: HR___0_25, HR___0_30: HR___0_30, HR___0_35: HR___0_35, HR___0_40: HR___0_40, HR___0_45: HR___0_45, HR___0_50: HR___0_50, HR___0_55: HR___0_55, HR___1_0: HR___1_0, HR_1_05: HR_1_05, HR___1_10: HR___1_10, HR___1_15: HR___1_15, HR___1_20: HR___1_20, HR___1_25: HR___1_25, HR___1_30: HR___1_30)
//        return try self.prediction(input: input_)
//    }
//
//    /**
//        Make a batch prediction using the structured interface
//
//        - parameters:
//           - inputs: the inputs to the prediction as [STORCTabularClassifier_Boosted_TreeInput]
//           - options: prediction options
//
//        - throws: an NSError object that describes the problem
//
//        - returns: the result of the prediction as [STORCTabularClassifier_Boosted_TreeOutput]
//    */
//    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
//    func predictions(inputs: [STORCTabularClassifier_Boosted_TreeInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [STORCTabularClassifier_Boosted_TreeOutput] {
//        let batchIn = MLArrayBatchProvider(array: inputs)
//        let batchOut = try model.predictions(from: batchIn, options: options)
//        var results : [STORCTabularClassifier_Boosted_TreeOutput] = []
//        results.reserveCapacity(inputs.count)
//        for i in 0..<batchOut.count {
//            let outProvider = batchOut.features(at: i)
//            let result =  STORCTabularClassifier_Boosted_TreeOutput(features: outProvider)
//            results.append(result)
//        }
//        return results
//    }
//}
