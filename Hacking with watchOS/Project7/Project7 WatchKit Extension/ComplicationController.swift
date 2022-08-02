//
//  ComplicationController.swift
//  Project7 WatchKit Extension
//
//  Created by Clinton de Sá Barreto Maciel on 01/08/22.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let positiveAnswers: Set<String> = ["It is certain", "It is decidedly so", "Without a doubt", "Yes definitely", "As I see it, yes", "Most likely", "Outlook good", "Yes", "Signs point to yes"]
    let uncertainAnswers: Set<String> = ["Reply hazy, try again", "Ask again later", "Better not tell you now", "Cannot predict now", "Concentrate and ask again"]
    let negativeAnswers: Set<String> = ["Don't count on it", "My reply is no", "My sources say no", "Outlook not so good", "Very doubtful"]
    var allAnswers = [String]()
    
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Project7", supportedFamilies: [.modularSmall, .modularLarge, .extraLarge, .graphicCircular, .graphicRectangular])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        allAnswers = Array(positiveAnswers) + Array(uncertainAnswers) + Array(negativeAnswers)
        let prediction = allAnswers.randomElement()
        let headerText = CLKSimpleTextProvider(text: "Magic 8-Ball")
        let body1Text = CLKSimpleTextProvider(text: prediction!)
        let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: headerText, body1TextProvider: body1Text)
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
        case .modularSmall:
            let text = CLKSimpleTextProvider(text: "❽")
            let template = CLKComplicationTemplateModularSmallSimpleText(textProvider: text)
            handler(template)
        case .modularLarge:
            let headerText = CLKSimpleTextProvider(text: "Magic 8-Ball", shortText: "8-Ball")
            let bodyText = CLKSimpleTextProvider(text: "Your prediction", shortText: "Prediction")
            let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: headerText, body1TextProvider: bodyText)
            handler(template)
        case .extraLarge:
            let line1 = CLKSimpleTextProvider(text: "Magic 8-Ball", shortText: "8-Ball")
            let line2 = CLKSimpleTextProvider(text: "Your prediction", shortText: "Prediction")
            let template = CLKComplicationTemplateExtraLargeStackText(line1TextProvider: line1, line2TextProvider: line2)
            handler(template)
        case .graphicCircular:
            let line1 = CLKSimpleTextProvider(text: "Magic 8-Ball", shortText: "❽")
            let line2 = CLKSimpleTextProvider(text: "Your prediction", shortText: "Prediction")
            let template = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: line1, line2TextProvider: line2)
            handler(template)
        case .graphicRectangular:
            let headerText = CLKSimpleTextProvider(text: "Magic 8-Ball", shortText: "8-Ball")
            let bodyText = CLKSimpleTextProvider(text: "Your prediction", shortText: "Prediction")
            let template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: headerText, body1TextProvider: bodyText)
            handler(template)
        default:
            let text = CLKSimpleTextProvider(text: "❽")
            let template = CLKComplicationTemplateModularSmallSimpleText(textProvider: text)
            handler(template)
        }
    }
}
