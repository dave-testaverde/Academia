//
//  Assistant.swift
//  Academia
//
//  Created by Dave on 21/01/25.
//

class Assistant {
    
    static func generateQuiz(
        of context: String = "geography in italy",
        difficulty: Int = 0
    ) -> String {
        return "Become an assistant to improve school readiness. Answer me with a single JSON object with a “question” property where you indicate the question, an “answer” property where you indicate the possible answers, and a “correct” property where you indicate the correct one via an integer index. The difficulty of the questions is based on a scale of integers from 0 to 10, in this case it is \(difficulty). The context is \(context). Do not enter additional text of any kind other than that strictly confined to the JSON object"
    }
}
