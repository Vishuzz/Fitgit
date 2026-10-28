//
//  ExerciseLibrary.swift
//  FitGit
//

import SwiftUI

public enum MuscleGroupCategory: String, CaseIterable, Identifiable, Codable {
    case chest = "Chest"
    case back = "Back"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case forearms = "Forearms"
    case quads = "Quads"
    case hamstrings = "Hamstrings"
    case glutes = "Glutes"
    case calves = "Calves"
    case core = "Core & Abs"
    case cardio = "Cardio"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .chest: return "figure.strengthtraining.traditional"
        case .back: return "figure.rower"
        case .shoulders: return "figure.arms.open"
        case .biceps: return "figure.boxing"
        case .triceps: return "figure.strengthtraining.functional"
        case .forearms: return "hand.raised.fill"
        case .quads: return "figure.run"
        case .hamstrings: return "figure.walk"
        case .glutes: return "figure.step.training"
        case .calves: return "figure.stair.stepper"
        case .core: return "figure.core.training"
        case .cardio: return "heart.fill"
        }
    }

    public var accentColor: Color {
        switch self {
        case .chest: return Color.orange
        case .back: return Color.blue
        case .shoulders: return Color.purple
        case .biceps: return Color.pink
        case .triceps: return Color.indigo
        case .forearms: return Color.teal
        case .quads: return Color.green
        case .hamstrings: return Color.mint
        case .glutes: return Color.red
        case .calves: return Color.yellow
        case .core: return Color.cyan
        case .cardio: return Color(red: 1.0, green: 0.25, blue: 0.35)
        }
    }
}

public struct ExerciseItem: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let primaryMuscle: MuscleGroupCategory
    public let secondaryMuscles: [String]
    public let equipment: String
    public let instructions: String
    public var isCustom: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        primaryMuscle: MuscleGroupCategory,
        secondaryMuscles: [String] = [],
        equipment: String = "Barbell",
        instructions: String = "",
        isCustom: Bool = false
    ) {
        self.id = id
        self.name = name
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.instructions = instructions
        self.isCustom = isCustom
    }
}

public final class ExerciseLibrary {
    public static let shared = ExerciseLibrary()

    public let allExercises: [ExerciseItem] = [
        // MARK: - CHEST
        ExerciseItem(name: "Barbell Bench Press", primaryMuscle: .chest, secondaryMuscles: ["Triceps", "Front Delts"], equipment: "Barbell", instructions: "Lower the bar with control to mid-chest, drive feet into the floor and press up explosively."),
        ExerciseItem(name: "Incline Dumbbell Press", primaryMuscle: .chest, secondaryMuscles: ["Upper Chest", "Front Delts"], equipment: "Dumbbells", instructions: "Set bench at 30-45 degrees, lower dumbbells to upper chest level and press upward."),
        ExerciseItem(name: "Decline Barbell Press", primaryMuscle: .chest, secondaryMuscles: ["Lower Chest", "Triceps"], equipment: "Barbell", instructions: "Lie on decline bench, lower bar to lower chest line and press up."),
        ExerciseItem(name: "Dumbbell Chest Fly", primaryMuscle: .chest, secondaryMuscles: ["Anterior Deltoid"], equipment: "Dumbbells", instructions: "Maintain slight elbow bend, open arms wide for a full chest stretch, squeeze chest at top."),
        ExerciseItem(name: "Cable Crossover (High to Low)", primaryMuscle: .chest, secondaryMuscles: ["Lower Chest"], equipment: "Cable", instructions: "Stand upright, bring cable handles downward and across each other with a squeeze."),
        ExerciseItem(name: "Incline Cable Fly", primaryMuscle: .chest, secondaryMuscles: ["Upper Chest"], equipment: "Cable", instructions: "Set cables low, press up and forward across the body."),
        ExerciseItem(name: "Pec Deck Machine", primaryMuscle: .chest, secondaryMuscles: [], equipment: "Machine", instructions: "Sit with back flat, press pads together using chest contraction, control return."),
        ExerciseItem(name: "Parallel Bar Dips (Chest Focus)", primaryMuscle: .chest, secondaryMuscles: ["Triceps"], equipment: "Bodyweight", instructions: "Lean torso forward 30 degrees, flare elbows slightly, lower until upper arms are parallel."),
        ExerciseItem(name: "Push-ups", primaryMuscle: .chest, secondaryMuscles: ["Core", "Triceps"], equipment: "Bodyweight", instructions: "Keep core tight in plank position, lower chest to floor and push up smoothly."),

        // MARK: - BACK
        ExerciseItem(name: "Barbell Deadlift", primaryMuscle: .back, secondaryMuscles: ["Glutes", "Hamstrings", "Traps"], equipment: "Barbell", instructions: "Hinge at hips, keep spine neutral, push floor away through heels to stand upright."),
        ExerciseItem(name: "Barbell Bent-Over Row", primaryMuscle: .back, secondaryMuscles: ["Biceps", "Lats"], equipment: "Barbell", instructions: "Hinge at 45 degrees, pull barbell into lower ribcage leading with elbows."),
        ExerciseItem(name: "Pull-ups (Overhand)", primaryMuscle: .back, secondaryMuscles: ["Biceps", "Upper Back"], equipment: "Bodyweight", instructions: "Grip slightly wider than shoulder width, initiate by pulling shoulder blades down, pull chin over bar."),
        ExerciseItem(name: "Chin-ups (Underhand)", primaryMuscle: .back, secondaryMuscles: ["Biceps"], equipment: "Bodyweight", instructions: "Supinated grip, pull chin over bar with strong bicep and lat involvement."),
        ExerciseItem(name: "Lat Pulldown (Wide Grip)", primaryMuscle: .back, secondaryMuscles: ["Biceps"], equipment: "Cable", instructions: "Sit with thighs secured, pull bar down toward upper chest, driving elbows down."),
        ExerciseItem(name: "Seated Cable Row", primaryMuscle: .back, secondaryMuscles: ["Rhomboids", "Biceps"], equipment: "Cable", instructions: "Sit upright, pull handle to abdomen while retracting shoulder blades."),
        ExerciseItem(name: "Single-Arm Dumbbell Row", primaryMuscle: .back, secondaryMuscles: ["Lats", "Biceps"], equipment: "Dumbbells", instructions: "Support knee and hand on bench, pull dumbbell up toward hip crease."),
        ExerciseItem(name: "T-Bar Row", primaryMuscle: .back, secondaryMuscles: ["Mid Back", "Traps"], equipment: "Machine", instructions: "Hinged stance, pull weight into chest with chest supported or free barbell landmine."),
        ExerciseItem(name: "Hyperextensions (Back Extension)", primaryMuscle: .back, secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Bodyweight", instructions: "Hinge forward at waist on 45-degree bench, extend hips to align with spine."),

        // MARK: - SHOULDERS
        ExerciseItem(name: "Overhead Barbell Press (OHP)", primaryMuscle: .shoulders, secondaryMuscles: ["Triceps", "Upper Chest"], equipment: "Barbell", instructions: "Stand tall, squeeze glutes, press bar straight up overhead clearing the chin."),
        ExerciseItem(name: "Dumbbell Shoulder Press", primaryMuscle: .shoulders, secondaryMuscles: ["Triceps"], equipment: "Dumbbells", instructions: "Sit upright, press dumbbells overhead in a gentle arc, avoid clanking at top."),
        ExerciseItem(name: "Dumbbell Lateral Raise", primaryMuscle: .shoulders, secondaryMuscles: ["Traps"], equipment: "Dumbbells", instructions: "Lead with elbows, raise arms out to side to shoulder height with pinkies slightly elevated."),
        ExerciseItem(name: "Cable Lateral Raise", primaryMuscle: .shoulders, secondaryMuscles: ["Side Delts"], equipment: "Cable", instructions: "Stand side-on to low cable, raise arm out across plane of body with constant tension."),
        ExerciseItem(name: "Arnold Press", primaryMuscle: .shoulders, secondaryMuscles: ["Triceps", "Front Delts"], equipment: "Dumbbells", instructions: "Start palms facing you at chin, rotate outward and press overhead in fluid motion."),
        ExerciseItem(name: "Face Pulls", primaryMuscle: .shoulders, secondaryMuscles: ["Rear Delts", "Rotator Cuff"], equipment: "Cable", instructions: "Pull rope attachment towards eyes/ears, rotating hands back and pinching shoulder blades."),
        ExerciseItem(name: "Reverse Pec Deck Fly", primaryMuscle: .shoulders, secondaryMuscles: ["Upper Back"], equipment: "Machine", instructions: "Chest against pad, swing handles back using rear deltoids."),
        ExerciseItem(name: "Front Dumbbell Raise", primaryMuscle: .shoulders, secondaryMuscles: ["Upper Chest"], equipment: "Dumbbells", instructions: "Raise dumbbells forward to eye level with controlled descent."),
        ExerciseItem(name: "Barbell Upright Row", primaryMuscle: .shoulders, secondaryMuscles: ["Traps", "Biceps"], equipment: "Barbell", instructions: "Pull bar upward along torso, leading with high elbows."),

        // MARK: - BICEPS
        ExerciseItem(name: "Barbell Bicep Curl", primaryMuscle: .biceps, secondaryMuscles: ["Forearms"], equipment: "Barbell", instructions: "Keep elbows glued at ribs, curl bar upward, squeeze biceps hard at peak contraction."),
        ExerciseItem(name: "Dumbbell Hammer Curl", primaryMuscle: .biceps, secondaryMuscles: ["Brachialis", "Forearms"], equipment: "Dumbbells", instructions: "Neutral grip palms facing inward, curl weights up to build arm thickness."),
        ExerciseItem(name: "Incline Dumbbell Curl", primaryMuscle: .biceps, secondaryMuscles: ["Long Head"], equipment: "Dumbbells", instructions: "Lie on 45-degree incline, let arms hang for deep stretch, curl upward."),
        ExerciseItem(name: "Preacher Curl", primaryMuscle: .biceps, secondaryMuscles: ["Short Head"], equipment: "EZ Bar", instructions: "Arms braced over pad to eliminate momentum, curl with strict focus."),
        ExerciseItem(name: "Cable Bicep Curl", primaryMuscle: .biceps, secondaryMuscles: ["Forearms"], equipment: "Cable", instructions: "Constant tension from bottom to top using straight bar or rope attachment."),
        ExerciseItem(name: "Concentration Curl", primaryMuscle: .biceps, secondaryMuscles: [], equipment: "Dumbbells", instructions: "Elbow braced on inner thigh, curl dumbbell with focused mind-muscle connection."),

        // MARK: - TRICEPS
        ExerciseItem(name: "Close-Grip Bench Press", primaryMuscle: .triceps, secondaryMuscles: ["Chest", "Front Delts"], equipment: "Barbell", instructions: "Hands shoulder-width apart, keep elbows tucked to sides, press upward."),
        ExerciseItem(name: "Tricep Rope Pushdown", primaryMuscle: .triceps, secondaryMuscles: ["Lateral Head"], equipment: "Cable", instructions: "Keep upper arms stationary, push rope down and spread handles apart at bottom."),
        ExerciseItem(name: "Skull Crushers (Lying Tricep Ext)", primaryMuscle: .triceps, secondaryMuscles: ["Long Head"], equipment: "EZ Bar", instructions: "Lie on bench, hinge at elbows to lower bar towards forehead/behind head, press up."),
        ExerciseItem(name: "Overhead Dumbbell Extension", primaryMuscle: .triceps, secondaryMuscles: ["Long Head"], equipment: "Dumbbells", instructions: "Hold dumbbell overhead with both hands, lower behind neck and extend upward."),
        ExerciseItem(name: "Cable Overhead Tricep Extension", primaryMuscle: .triceps, secondaryMuscles: [], equipment: "Cable", instructions: "Face away from high cable with rope, extend elbows overhead forward."),
        ExerciseItem(name: "Bench Dips", primaryMuscle: .triceps, secondaryMuscles: ["Front Delts"], equipment: "Bodyweight", instructions: "Hands on bench edge behind you, lower hips and push through palms."),

        // MARK: - FOREARMS
        ExerciseItem(name: "Barbell Wrist Curl", primaryMuscle: .forearms, secondaryMuscles: [], equipment: "Barbell", instructions: "Forearms resting on bench, curl wrists upward with palms up."),
        ExerciseItem(name: "Reverse Barbell Wrist Curl", primaryMuscle: .forearms, secondaryMuscles: [], equipment: "Barbell", instructions: "Forearms on bench, curl wrists upward with palms down."),
        ExerciseItem(name: "Farmer's Walk", primaryMuscle: .forearms, secondaryMuscles: ["Traps", "Core", "Grip"], equipment: "Dumbbells", instructions: "Pick up heavy weights at sides, walk with tall posture and firm grip."),
        ExerciseItem(name: "Dead Hang", primaryMuscle: .forearms, secondaryMuscles: ["Lats", "Grip"], equipment: "Bodyweight", instructions: "Hang from pull-up bar for maximum grip endurance and spinal decompression."),

        // MARK: - QUADS
        ExerciseItem(name: "Barbell Back Squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes", "Hamstrings", "Core"], equipment: "Barbell", instructions: "Bar across traps, descend till thighs are parallel to ground, drive up through midfoot."),
        ExerciseItem(name: "Barbell Front Squat", primaryMuscle: .quads, secondaryMuscles: ["Core", "Upper Back"], equipment: "Barbell", instructions: "Bar in clean rack or cross-arm grip, keep torso completely upright, squat deep."),
        ExerciseItem(name: "Leg Press", primaryMuscle: .quads, secondaryMuscles: ["Glutes"], equipment: "Machine", instructions: "Feet shoulder-width on platform, lower sled till knees reach 90 degrees, press without locking knees."),
        ExerciseItem(name: "Bulgarian Split Squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Dumbbells", instructions: "Rear foot on bench, descend front knee into a deep lunge and drive back up."),
        ExerciseItem(name: "Leg Extension Machine", primaryMuscle: .quads, secondaryMuscles: [], equipment: "Machine", instructions: "Sit back against pad, extend legs to full knee extension with 1-second squeeze."),
        ExerciseItem(name: "Hack Squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes"], equipment: "Machine", instructions: "Back flat against sled, descend smoothly with knees tracking over toes, press upward."),
        ExerciseItem(name: "Walking Dumbbell Lunges", primaryMuscle: .quads, secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Dumbbells", instructions: "Take long strides, lower back knee near floor, push through front heel to step forward."),

        // MARK: - HAMSTRINGS
        ExerciseItem(name: "Romanian Deadlift (RDL)", primaryMuscle: .hamstrings, secondaryMuscles: ["Glutes", "Lower Back"], equipment: "Barbell", instructions: "Slight knee bend, push hips far back to feel intense hamstring stretch, contract glutes to return."),
        ExerciseItem(name: "Lying Leg Curl Machine", primaryMuscle: .hamstrings, secondaryMuscles: ["Calves"], equipment: "Machine", instructions: "Lie prone, curl heels towards glutes, control the eccentric return."),
        ExerciseItem(name: "Seated Leg Curl Machine", primaryMuscle: .hamstrings, secondaryMuscles: [], equipment: "Machine", instructions: "Thigh pad locked down, curl heels beneath seat for deep hamstring contraction."),
        ExerciseItem(name: "Good Mornings", primaryMuscle: .hamstrings, secondaryMuscles: ["Lower Back", "Glutes"], equipment: "Barbell", instructions: "Bar on upper back, hinge at hips while keeping chest proud, return to standing."),

        // MARK: - GLUTES
        ExerciseItem(name: "Barbell Hip Thrust", primaryMuscle: .glutes, secondaryMuscles: ["Hamstrings"], equipment: "Barbell", instructions: "Upper back on bench, barbell over hip crease, drive through heels into full hip extension."),
        ExerciseItem(name: "Cable Glute Kickbacks", primaryMuscle: .glutes, secondaryMuscles: [], equipment: "Cable", instructions: "Ankle strap on low cable, kick leg backward squeezing glute at top."),
        ExerciseItem(name: "Glute Bridge", primaryMuscle: .glutes, secondaryMuscles: ["Core"], equipment: "Bodyweight", instructions: "Lie on back with knees bent, push hips up towards ceiling and squeeze glutes."),
        ExerciseItem(name: "Cable Pull-Through", primaryMuscle: .glutes, secondaryMuscles: ["Hamstrings"], equipment: "Cable", instructions: "Straddle low rope cable, hinge hips back between legs and thrust hips forward."),

        // MARK: - CALVES
        ExerciseItem(name: "Standing Calf Raise", primaryMuscle: .calves, secondaryMuscles: ["Gastrocnemius"], equipment: "Machine", instructions: "Balls of feet on ledge, drop heels for deep stretch, rise high onto toes."),
        ExerciseItem(name: "Seated Calf Raise", primaryMuscle: .calves, secondaryMuscles: ["Soleus"], equipment: "Machine", instructions: "Knees bent 90 degrees under pad, lift heels through full range of motion."),
        ExerciseItem(name: "Donkey Calf Raise", primaryMuscle: .calves, secondaryMuscles: ["Gastrocnemius"], equipment: "Machine", instructions: "Hips bent 90 degrees, elevate onto balls of feet with deep stretch at bottom."),

        // MARK: - CORE & ABS
        ExerciseItem(name: "Hanging Leg Raise", primaryMuscle: .core, secondaryMuscles: ["Hip Flexors"], equipment: "Bodyweight", instructions: "Hang from pull-up bar, curl hips and knees/toes up toward chest without swinging."),
        ExerciseItem(name: "Ab Wheel Rollout", primaryMuscle: .core, secondaryMuscles: ["Lats", "Shoulders"], equipment: "Bodyweight", instructions: "Kneel on floor, roll wheel forward keeping core hollow, pull back using abs."),
        ExerciseItem(name: "Cable Woodchopper", primaryMuscle: .core, secondaryMuscles: ["Obliques"], equipment: "Cable", instructions: "Rotate torso across body from high to low or low to high against cable resistance."),
        ExerciseItem(name: "Plank (Front)", primaryMuscle: .core, secondaryMuscles: ["Shoulders", "Glutes"], equipment: "Bodyweight", instructions: "Forearms on floor, maintain perfectly straight line from head to heels, bracing abdomen."),
        ExerciseItem(name: "Decline Bench Crunch", primaryMuscle: .core, secondaryMuscles: [], equipment: "Bodyweight", instructions: "Feet hooked on decline bench, curl ribcage towards pelvis with tension."),
        ExerciseItem(name: "Russian Twists", primaryMuscle: .core, secondaryMuscles: ["Obliques"], equipment: "Bodyweight", instructions: "Sit in V-shape with feet elevated, rotate torso side to side touching ground."),

        // MARK: - CARDIO & CONDITIONING
        ExerciseItem(name: "Treadmill Running / Incline Walk", primaryMuscle: .cardio, secondaryMuscles: ["Legs", "Calves"], equipment: "Cardio", instructions: "Aerobic or HIIT intervals on treadmill."),
        ExerciseItem(name: "Rowing Machine (Ergometer)", primaryMuscle: .cardio, secondaryMuscles: ["Back", "Legs", "Arms"], equipment: "Cardio", instructions: "Drive with legs, lean back slightly, pull handle to lower sternum."),
        ExerciseItem(name: "Stair Climber (Stairmaster)", primaryMuscle: .cardio, secondaryMuscles: ["Glutes", "Quads", "Calves"], equipment: "Cardio", instructions: "Climb steps with upright posture without leaning heavily on handrails."),
        ExerciseItem(name: "Jump Rope", primaryMuscle: .cardio, secondaryMuscles: ["Calves", "Shoulders"], equipment: "Bodyweight", instructions: "Light on balls of feet, turn rope using wrist movement."),
        ExerciseItem(name: "Assault / Air Bike", primaryMuscle: .cardio, secondaryMuscles: ["Full Body"], equipment: "Cardio", instructions: "Push and pull handles while pedaling with maximum power.")
    ]

    public func exercises(for category: MuscleGroupCategory) -> [ExerciseItem] {
        allExercises.filter { $0.primaryMuscle == category }
    }
}
