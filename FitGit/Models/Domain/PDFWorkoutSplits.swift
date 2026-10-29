//
//  PDFWorkoutSplits.swift
//  FitGit
//
//  Exact exercise routines, sets, and rep ranges compiled from
//  "Complete Gym Workout Splits" guide (Pages 1-13).
//

import Foundation

public struct PDFSplitProgram: Identifiable {
    public var id: String { name }
    public let name: String
    public let daysPerWeek: String
    public let bestSuitedFor: String
    public let overview: String
    public let dailyConfigs: [DayWorkoutConfig]
}

public enum PDFExerciseFactory {
    public static func make(
        name: String,
        primaryMuscle: MuscleGroupCategory,
        targetMusclePart: String = "",
        secondaryMuscles: [String] = [],
        equipment: String,
        sets: Int,
        reps: String,
        instructions: String = ""
    ) -> ExerciseItem {
        ExerciseItem(
            name: name,
            primaryMuscle: primaryMuscle,
            targetMusclePart: targetMusclePart,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            instructions: instructions.isEmpty ? "Finish working sets with 1-3 repetitions in reserve (RIR). Rest 2-3 mins on compounds and 60-120s on isolations." : instructions,
            targetSets: sets,
            targetRepsRange: reps
        )
    }

    // MARK: - Chest
    public static func barbellBenchPress(sets: Int = 3, reps: String = "6-8") -> ExerciseItem {
        make(name: "Barbell bench press", primaryMuscle: .chest, secondaryMuscles: ["Triceps", "Front Delts"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Lower the bar with control to mid-chest, drive feet into the floor and press up explosively.")
    }

    public static func inclineDumbbellPress(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Incline dumbbell press", primaryMuscle: .chest, secondaryMuscles: ["Upper Chest", "Front Delts"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Set bench at 30-45 degrees, lower dumbbells to upper chest level and press upward.")
    }

    public static func inclineBarbellPress(sets: Int = 3, reps: String = "6-8") -> ExerciseItem {
        make(name: "Incline barbell press", primaryMuscle: .chest, secondaryMuscles: ["Upper Chest", "Triceps"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Barbell on incline bench, control descent to collarbone line and press strong.")
    }

    public static func machineChestPress(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Machine chest press", primaryMuscle: .chest, secondaryMuscles: ["Triceps"], equipment: "Machine", sets: sets, reps: reps, instructions: "Press handles straight forward with full pectoral extension and controlled return.")
    }

    public static func cableFly(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Cable fly", primaryMuscle: .chest, secondaryMuscles: ["Anterior Deltoid"], equipment: "Cable", sets: sets, reps: reps, instructions: "Slight elbow bend, bring handles together in front of chest with continuous tension.")
    }

    public static func cableCrossover(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Cable crossover", primaryMuscle: .chest, secondaryMuscles: ["Lower Chest"], equipment: "Cable", sets: sets, reps: reps, instructions: "Bring pulleys from high to low, crossing wrists slightly for peak contraction.")
    }

    public static func pecDeckCableFly(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Pec deck / cable fly", primaryMuscle: .chest, secondaryMuscles: ["Anterior Delts"], equipment: "Machine / Cable", sets: sets, reps: reps, instructions: "Pad or handles sweep forward across body, focusing entirely on pectoral adduction.")
    }

    public static func weightedDipsAssisted(sets: Int = 2, reps: String = "8-12") -> ExerciseItem {
        make(name: "Weighted dips / assisted dips", primaryMuscle: .chest, secondaryMuscles: ["Triceps", "Shoulders"], equipment: "Bodyweight / Machine", sets: sets, reps: reps, instructions: "Lean forward 30 degrees to bias chest fibers, lower until upper arms hit 90 degrees.")
    }

    // MARK: - Back
    public static func pullUpsLatPulldown(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Pull-ups / lat pulldown", primaryMuscle: .back, secondaryMuscles: ["Biceps", "Upper Back"], equipment: "Bodyweight / Cable", sets: sets, reps: reps, instructions: "Overhand grip, drive elbows down into sides and pull chest to bar/cable attachment.")
    }

    public static func latPulldown(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Lat pulldown", primaryMuscle: .back, secondaryMuscles: ["Biceps"], equipment: "Cable", sets: sets, reps: reps, instructions: "Lock knees under pads, pull down smoothly to upper chest.")
    }

    public static func neutralGripLatPulldown(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Neutral-grip lat pulldown", primaryMuscle: .back, secondaryMuscles: ["Biceps", "Brachialis"], equipment: "Cable", sets: sets, reps: reps, instructions: "Use V-bar or parallel grip, pull to upper sternum keeping chest up.")
    }

    public static func neutralGripPulldown(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Neutral-grip pulldown", primaryMuscle: .back, secondaryMuscles: ["Biceps"], equipment: "Cable", sets: sets, reps: reps, instructions: "Parallel grip pulldown maximizing lat engagement.")
    }

    public static func barbellRow(sets: Int = 3, reps: String = "6-10") -> ExerciseItem {
        make(name: "Barbell row", primaryMuscle: .back, secondaryMuscles: ["Biceps", "Lats", "Spinal Erectors"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Hinge torso at 45 degrees, pull barbell into waistline leading with elbows.")
    }

    public static func barbellOrChestSupportedRow(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Barbell or chest-supported row", primaryMuscle: .back, secondaryMuscles: ["Rhomboids", "Biceps"], equipment: "Barbell / Machine", sets: sets, reps: reps, instructions: "Row weight toward lower ribcage without momentum or lower back swing.")
    }

    public static func chestSupportedRow(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Chest-supported row", primaryMuscle: .back, secondaryMuscles: ["Rhomboids", "Mid Back"], equipment: "Machine / Dumbbells", sets: sets, reps: reps, instructions: "Chest resting on incline pad, row handles back with full scapular retraction.")
    }

    public static func seatedCableRow(sets: Int = 2, reps: String = "10-12") -> ExerciseItem {
        make(name: "Seated cable row", primaryMuscle: .back, secondaryMuscles: ["Rhomboids", "Lats"], equipment: "Cable", sets: sets, reps: reps, instructions: "Sit upright, pull handle into belly button while squeezing shoulder blades.")
    }

    public static func oneArmDumbbellRow(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "One-arm dumbbell row", primaryMuscle: .back, secondaryMuscles: ["Lats", "Biceps"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Knee and hand on bench, pull dumbbell up to hip crease.")
    }

    public static func machineRow(sets: Int = 2, reps: String = "10-12") -> ExerciseItem {
        make(name: "Machine row", primaryMuscle: .back, secondaryMuscles: ["Upper Back"], equipment: "Machine", sets: sets, reps: reps, instructions: "Chest against pad, pull levers back with strict horizontal arm drive.")
    }

    public static func straightArmPulldown(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Straight-arm pulldown", primaryMuscle: .back, secondaryMuscles: ["Lats", "Core"], equipment: "Cable", sets: sets, reps: reps, instructions: "Arms extended straight with slight elbow bend, sweep cable down to thighs.")
    }

    public static func dumbbellShrugs(sets: Int = 2, reps: String = "10-15") -> ExerciseItem {
        make(name: "Dumbbell shrugs", primaryMuscle: .back, secondaryMuscles: ["Traps"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Elevate shoulders straight towards ears, hold peak contraction for 1 second.")
    }

    // MARK: - Shoulders
    public static func seatedDumbbellShoulderPress(sets: Int = 3, reps: String = "8-10") -> ExerciseItem {
        make(name: "Seated dumbbell shoulder press", primaryMuscle: .shoulders, secondaryMuscles: ["Triceps"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Press dumbbells up in a natural arc from shoulder height, avoiding clanking at top.")
    }

    public static func machineShoulderPress(sets: Int = 2, reps: String = "8-12") -> ExerciseItem {
        make(name: "Machine shoulder press", primaryMuscle: .shoulders, secondaryMuscles: ["Triceps"], equipment: "Machine", sets: sets, reps: reps, instructions: "Sit upright against backrest, press overhead in locked mechanical path.")
    }

    public static func cableLateralRaises(sets: Int = 3, reps: String = "12-15") -> ExerciseItem {
        make(name: "Cable lateral raises", primaryMuscle: .shoulders, secondaryMuscles: ["Side Delts"], equipment: "Cable", sets: sets, reps: reps, instructions: "Low cable pulley, sweep arm outward up to shoulder level with constant tension.")
    }

    public static func dumbbellLateralRaises(sets: Int = 3, reps: String = "12-20") -> ExerciseItem {
        make(name: "Dumbbell lateral raises", primaryMuscle: .shoulders, secondaryMuscles: ["Side Delts"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Lead with elbows and slight forward tilt, raising arms to parallel.")
    }

    public static func reversePecDeck(sets: Int = 3, reps: String = "12-15") -> ExerciseItem {
        make(name: "Reverse pec deck", primaryMuscle: .shoulders, secondaryMuscles: ["Rear Delts", "Upper Back"], equipment: "Machine", sets: sets, reps: reps, instructions: "Chest to pad, fly handles rearward using posterior deltoids.")
    }

    public static func rearDeltCableFly(sets: Int = 3, reps: String = "12-15") -> ExerciseItem {
        make(name: "Rear-delt cable fly", primaryMuscle: .shoulders, secondaryMuscles: ["Rear Delts"], equipment: "Cable", sets: sets, reps: reps, instructions: "Crossed high cables without handles, pull outward and back horizontally.")
    }

    public static func reverseCableFly(sets: Int = 3, reps: String = "12-15") -> ExerciseItem {
        make(name: "Reverse cable fly", primaryMuscle: .shoulders, secondaryMuscles: ["Rear Delts"], equipment: "Cable", sets: sets, reps: reps, instructions: "Rearward horizontal cable sweep targeting rear delts.")
    }

    public static func facePulls(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Face pulls", primaryMuscle: .shoulders, secondaryMuscles: ["Rear Delts", "Rotator Cuff"], equipment: "Cable", sets: sets, reps: reps, instructions: "Pull rope towards eyes, externally rotating hands at finish.")
    }

    // MARK: - Arms
    public static func ezBarCurl(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "EZ-bar curl", primaryMuscle: .biceps, secondaryMuscles: ["Forearms"], equipment: "EZ Bar", sets: sets, reps: reps, instructions: "Semi-supinated grip on cambered bar, curl up keeping upper arms pinned.")
    }

    public static func inclineDumbbellCurl(sets: Int = 2, reps: String = "10-15") -> ExerciseItem {
        make(name: "Incline dumbbell curl", primaryMuscle: .biceps, secondaryMuscles: ["Long Head"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Incline 45-60 deg, full stretch at bottom, curl without swinging elbows.")
    }

    public static func preacherCurl(sets: Int = 3, reps: String = "10-12") -> ExerciseItem {
        make(name: "Preacher curl", primaryMuscle: .biceps, secondaryMuscles: ["Short Head"], equipment: "EZ Bar / Dumbbells", sets: sets, reps: reps, instructions: "Triceps glued on pad, lower to controlled stretch and curl to peak contraction.")
    }

    public static func hammerCurl(sets: Int = 2, reps: String = "10-15") -> ExerciseItem {
        make(name: "Hammer curl", primaryMuscle: .biceps, secondaryMuscles: ["Brachialis", "Forearms"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Neutral grip palms facing inward, curl weights up with strict control.")
    }

    public static func tricepsRopePushdown(sets: Int = 3, reps: String = "10-15") -> ExerciseItem {
        make(name: "Triceps rope pushdown", primaryMuscle: .triceps, secondaryMuscles: ["Lateral Head"], equipment: "Cable", sets: sets, reps: reps, instructions: "Elbows by your sides, push rope down and spread handles apart at bottom lockout.")
    }

    public static func tricepsPushdown(sets: Int = 2, reps: String = "10-15") -> ExerciseItem {
        make(name: "Triceps pushdown", primaryMuscle: .triceps, secondaryMuscles: ["Lateral Head"], equipment: "Cable", sets: sets, reps: reps, instructions: "Straight bar or V-bar pushdown focusing on triceps contraction.")
    }

    public static func ropePushdown(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Rope pushdown", primaryMuscle: .triceps, secondaryMuscles: ["Lateral Head"], equipment: "Cable", sets: sets, reps: reps, instructions: "Cable rope pushdown with hard lockout at the bottom.")
    }

    public static func overheadCableTricepsExtension(sets: Int = 2, reps: String = "10-15") -> ExerciseItem {
        make(name: "Overhead cable triceps extension", primaryMuscle: .triceps, secondaryMuscles: ["Long Head"], equipment: "Cable", sets: sets, reps: reps, instructions: "Facing away from high or low cable, extend elbows overhead.")
    }

    public static func overheadTricepsExtension(sets: Int = 2, reps: String = "10-15") -> ExerciseItem {
        make(name: "Overhead triceps extension", primaryMuscle: .triceps, secondaryMuscles: ["Long Head"], equipment: "Dumbbell / Cable", sets: sets, reps: reps, instructions: "Lower weight behind head with elbows pointed upward, extend completely.")
    }

    public static func closeGripBenchPress(sets: Int = 3, reps: String = "6-10") -> ExerciseItem {
        make(name: "Close-grip bench press", primaryMuscle: .triceps, secondaryMuscles: ["Chest"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Hands shoulder-width apart, elbows tucked, press up.")
    }

    public static func ezBarSkullCrushers(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "EZ-bar skull crushers", primaryMuscle: .triceps, secondaryMuscles: ["Long Head"], equipment: "EZ Bar", sets: sets, reps: reps, instructions: "Lie on bench, bend elbows to lower bar to forehead/behind crown, extend up.")
    }

    public static func wristCurlsOptional(sets: Int = 2, reps: String = "12-20") -> ExerciseItem {
        make(name: "Wrist curls (optional)", primaryMuscle: .forearms, secondaryMuscles: [], equipment: "Barbell / Dumbbell", sets: sets, reps: reps, instructions: "Forearms supported on bench, curl wrists upward with control.")
    }

    // MARK: - Legs & Abs
    public static func barbellSquat(sets: Int = 3, reps: String = "6-10") -> ExerciseItem {
        make(name: "Barbell squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Bar across traps, descend till thighs are parallel, drive up through midfoot.")
    }

    public static func hackSquatOrSquat(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Hack squat or squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes"], equipment: "Machine / Barbell", sets: sets, reps: reps, instructions: "Deep hack squat or back squat alternative focusing on quad development.")
    }

    public static func hackSquat(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Hack squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes"], equipment: "Machine", sets: sets, reps: reps, instructions: "Back flat on hack squat sled, descend deep and press up through whole foot.")
    }

    public static func legPress(sets: Int = 3, reps: String = "10-12") -> ExerciseItem {
        make(name: "Leg press", primaryMuscle: .quads, secondaryMuscles: ["Glutes"], equipment: "Machine", sets: sets, reps: reps, instructions: "Lower sled to 90 degrees at knees, press through midfoot without locking knees.")
    }

    public static func legPressHackSquat(sets: Int = 3, reps: String = "8-12") -> ExerciseItem {
        make(name: "Leg press / hack squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes"], equipment: "Machine", sets: sets, reps: reps, instructions: "Perform either machine leg press or hack squat for quad overload.")
    }

    public static func bulgarianSplitSquat(sets: Int = 2, reps: String = "8-12 per leg") -> ExerciseItem {
        make(name: "Bulgarian split squat", primaryMuscle: .quads, secondaryMuscles: ["Glutes", "Hamstrings"], equipment: "Dumbbells", sets: sets, reps: reps, instructions: "Rear foot on bench, lower front thigh parallel to ground and drive back up.")
    }

    public static func legExtension(sets: Int = 2, reps: String = "12-15") -> ExerciseItem {
        make(name: "Leg extension", primaryMuscle: .quads, secondaryMuscles: [], equipment: "Machine", sets: sets, reps: reps, instructions: "Extend legs fully, pause 1 second at top contraction, lower under control.")
    }

    public static func romanianDeadlift(sets: Int = 3, reps: String = "8-10") -> ExerciseItem {
        make(name: "Romanian deadlift", primaryMuscle: .hamstrings, secondaryMuscles: ["Glutes", "Lower Back"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Slight knee bend, hinge hips backward until hamstring stretch, drive hips forward to lockout.")
    }

    public static func seatedLegCurl(sets: Int = 3, reps: String = "10-15") -> ExerciseItem {
        make(name: "Seated leg curl", primaryMuscle: .hamstrings, secondaryMuscles: [], equipment: "Machine", sets: sets, reps: reps, instructions: "Lap pad pinned securely, curl heels under seat, control return.")
    }

    public static func lyingLegCurl(sets: Int = 3, reps: String = "10-15") -> ExerciseItem {
        make(name: "Lying leg curl", primaryMuscle: .hamstrings, secondaryMuscles: [], equipment: "Machine", sets: sets, reps: reps, instructions: "Lie face down, curl roller toward glutes, keeping hips pressed on bench.")
    }

    public static func hipThrust(sets: Int = 2, reps: String = "8-12") -> ExerciseItem {
        make(name: "Hip thrust", primaryMuscle: .glutes, secondaryMuscles: ["Hamstrings"], equipment: "Barbell", sets: sets, reps: reps, instructions: "Upper back on bench, drive barbell through heels to horizontal hip lockout.")
    }

    public static func standingCalfRaises(sets: Int = 3, reps: String = "12-20") -> ExerciseItem {
        make(name: "Standing calf raises", primaryMuscle: .calves, secondaryMuscles: [], equipment: "Machine", sets: sets, reps: reps, instructions: "Deep stretch at bottom, press onto balls of feet, hold peak contraction.")
    }

    public static func seatedCalfRaises(sets: Int = 3, reps: String = "12-20") -> ExerciseItem {
        make(name: "Seated calf raises", primaryMuscle: .calves, secondaryMuscles: [], equipment: "Machine", sets: sets, reps: reps, instructions: "Targets soleus calf muscle. Full range of motion with smooth tempo.")
    }

    public static func hangingKneeRaises(sets: Int = 3, reps: String = "10-15") -> ExerciseItem {
        make(name: "Hanging knee raises", primaryMuscle: .core, secondaryMuscles: ["Hip Flexors"], equipment: "Bodyweight", sets: sets, reps: reps, instructions: "Hang from bar, tilt pelvis and curl knees up to chest without swinging.")
    }

    public static func cableCrunches(sets: Int = 3, reps: String = "12-15") -> ExerciseItem {
        make(name: "Cable crunches", primaryMuscle: .core, secondaryMuscles: [], equipment: "Cable", sets: sets, reps: reps, instructions: "Kneel beneath high rope cable, curl sternum towards hips using rectus abdominis.")
    }
}

// MARK: - PDF Complete Gym Workout Splits Catalog
public enum PDFWorkoutSplits {
    private static var defaultTime: Date {
        Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date()) ?? Date()
    }

    // 1. Push-Pull-Legs (PPL) - Pages 3-4
    public static var pushPullLegsSchedule: [DayWorkoutConfig] {
        [
            DayWorkoutConfig(
                day: .monday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest, .shoulders, .triceps],
                routineTitle: "Day 1 - Push (Chest, Shoulders, Triceps)",
                customExercises: [
                    PDFExerciseFactory.barbellBenchPress(sets: 3, reps: "6-8"),
                    PDFExerciseFactory.inclineDumbbellPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.seatedDumbbellShoulderPress(sets: 3, reps: "8-10"),
                    PDFExerciseFactory.cableLateralRaises(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.pecDeckCableFly(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.tricepsRopePushdown(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.overheadCableTricepsExtension(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .tuesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.back, .biceps, .shoulders],
                routineTitle: "Day 2 - Pull (Back, Biceps, Rear Delts)",
                customExercises: [
                    PDFExerciseFactory.pullUpsLatPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.chestSupportedRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.seatedCableRow(sets: 2, reps: "10-12"),
                    PDFExerciseFactory.straightArmPulldown(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.reversePecDeck(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.ezBarCurl(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.inclineDumbbellCurl(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .wednesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .hamstrings, .calves, .core],
                routineTitle: "Day 3 - Legs and Abs",
                customExercises: [
                    PDFExerciseFactory.barbellSquat(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.romanianDeadlift(sets: 3, reps: "8-10"),
                    PDFExerciseFactory.legPress(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.seatedLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.legExtension(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.standingCalfRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.hangingKneeRaises(sets: 3, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .thursday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest, .shoulders, .triceps],
                routineTitle: "Day 4 - Push (Variation)",
                customExercises: [
                    PDFExerciseFactory.inclineBarbellPress(sets: 3, reps: "6-8"),
                    PDFExerciseFactory.machineChestPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.machineShoulderPress(sets: 2, reps: "8-12"),
                    PDFExerciseFactory.dumbbellLateralRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.cableFly(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.overheadTricepsExtension(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.tricepsPushdown(sets: 2, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .friday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.back, .biceps, .shoulders],
                routineTitle: "Day 5 - Pull (Variation)",
                customExercises: [
                    PDFExerciseFactory.neutralGripLatPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.oneArmDumbbellRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.machineRow(sets: 2, reps: "10-12"),
                    PDFExerciseFactory.rearDeltCableFly(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.dumbbellShrugs(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.preacherCurl(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.hammerCurl(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .saturday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .hamstrings, .calves, .core],
                routineTitle: "Day 6 - Legs (Variation)",
                customExercises: [
                    PDFExerciseFactory.hackSquatOrSquat(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.romanianDeadlift(sets: 3, reps: "8-10"),
                    PDFExerciseFactory.bulgarianSplitSquat(sets: 2, reps: "8-12 per leg"),
                    PDFExerciseFactory.seatedLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.legExtension(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.seatedCalfRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.cableCrunches(sets: 3, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .sunday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 7 - Rest & Recovery",
                customExercises: []
            )
        ]
    }

    // 2. Arnold Split - Pages 5-6
    public static var arnoldSplitSchedule: [DayWorkoutConfig] {
        [
            DayWorkoutConfig(
                day: .monday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest, .back],
                routineTitle: "Day 1 - Chest and Back",
                customExercises: [
                    PDFExerciseFactory.barbellBenchPress(sets: 3, reps: "6-8"),
                    PDFExerciseFactory.inclineDumbbellPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.weightedDipsAssisted(sets: 2, reps: "8-12"),
                    PDFExerciseFactory.pullUpsLatPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.barbellOrChestSupportedRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.straightArmPulldown(sets: 2, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .tuesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.shoulders, .biceps, .triceps],
                routineTitle: "Day 2 - Shoulders and Arms",
                customExercises: [
                    PDFExerciseFactory.seatedDumbbellShoulderPress(sets: 3, reps: "8-10"),
                    PDFExerciseFactory.dumbbellLateralRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.reversePecDeck(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.ezBarCurl(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.inclineDumbbellCurl(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.tricepsRopePushdown(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.overheadTricepsExtension(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .wednesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .hamstrings, .calves, .core],
                routineTitle: "Day 3 - Legs and Abs",
                customExercises: [
                    PDFExerciseFactory.barbellSquat(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.romanianDeadlift(sets: 3, reps: "8-10"),
                    PDFExerciseFactory.legPress(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.lyingLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.legExtension(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.standingCalfRaises(sets: 4, reps: "12-20"),
                    PDFExerciseFactory.cableCrunches(sets: 3, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .thursday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest, .back],
                routineTitle: "Day 4 - Chest and Back (Variation)",
                customExercises: [
                    PDFExerciseFactory.inclineBarbellPress(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.machineChestPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.cableCrossover(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.neutralGripPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.seatedCableRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.chestSupportedRow(sets: 2, reps: "10-12")
                ]
            ),
            DayWorkoutConfig(
                day: .friday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.shoulders, .biceps, .triceps],
                routineTitle: "Day 5 - Shoulders and Arms (Variation)",
                customExercises: [
                    PDFExerciseFactory.machineShoulderPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.cableLateralRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.reverseCableFly(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.preacherCurl(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.hammerCurl(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.ezBarSkullCrushers(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.ropePushdown(sets: 2, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .saturday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .hamstrings, .glutes, .calves, .core],
                routineTitle: "Day 6 - Legs and Abs (Variation)",
                customExercises: [
                    PDFExerciseFactory.hackSquat(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.bulgarianSplitSquat(sets: 2, reps: "8-12 per leg"),
                    PDFExerciseFactory.seatedLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.hipThrust(sets: 2, reps: "8-12"),
                    PDFExerciseFactory.legExtension(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.seatedCalfRaises(sets: 4, reps: "12-20"),
                    PDFExerciseFactory.hangingKneeRaises(sets: 3, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .sunday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 7 - Rest & Recovery",
                customExercises: []
            )
        ]
    }

    // 3. Upper/Lower Split - Pages 7-8
    public static var upperLowerSchedule: [DayWorkoutConfig] {
        [
            DayWorkoutConfig(
                day: .monday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest, .back, .shoulders, .biceps, .triceps],
                routineTitle: "Day 1 - Upper A (Strength Focus)",
                customExercises: [
                    PDFExerciseFactory.barbellBenchPress(sets: 3, reps: "5-8"),
                    PDFExerciseFactory.barbellRow(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.inclineDumbbellPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.latPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.dumbbellLateralRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.ezBarCurl(sets: 2, reps: "10-12"),
                    PDFExerciseFactory.tricepsPushdown(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .tuesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .hamstrings, .calves, .core],
                routineTitle: "Day 2 - Lower A (Strength Focus)",
                customExercises: [
                    PDFExerciseFactory.barbellSquat(sets: 3, reps: "5-8"),
                    PDFExerciseFactory.romanianDeadlift(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.legPress(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.seatedLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.standingCalfRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.cableCrunches(sets: 3, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .wednesday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 3 - Rest & Mobility (Optional)",
                customExercises: []
            ),
            DayWorkoutConfig(
                day: .thursday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest, .back, .shoulders, .biceps, .triceps],
                routineTitle: "Day 4 - Upper B (Hypertrophy Focus)",
                customExercises: [
                    PDFExerciseFactory.inclineBarbellPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.chestSupportedRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.machineChestPress(sets: 2, reps: "10-12"),
                    PDFExerciseFactory.neutralGripLatPulldown(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.cableLateralRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.reversePecDeck(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.preacherCurl(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.overheadTricepsExtension(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .friday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .glutes, .hamstrings, .calves, .core],
                routineTitle: "Day 5 - Lower B (Hypertrophy Focus)",
                customExercises: [
                    PDFExerciseFactory.hackSquat(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.hipThrust(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.bulgarianSplitSquat(sets: 2, reps: "8-12 per leg"),
                    PDFExerciseFactory.lyingLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.legExtension(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.seatedCalfRaises(sets: 3, reps: "12-20"),
                    PDFExerciseFactory.hangingKneeRaises(sets: 3, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .saturday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 6 - Rest & Recovery",
                customExercises: []
            ),
            DayWorkoutConfig(
                day: .sunday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 7 - Rest & Recovery",
                customExercises: []
            )
        ]
    }

    // 4. Classic Bro Split - Pages 9-10
    public static var broSplitSchedule: [DayWorkoutConfig] {
        [
            DayWorkoutConfig(
                day: .monday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.chest],
                routineTitle: "Day 1 - Chest",
                customExercises: [
                    PDFExerciseFactory.barbellBenchPress(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.inclineDumbbellPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.machineChestPress(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.cableFly(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.weightedDipsAssisted(sets: 2, reps: "8-12")
                ]
            ),
            DayWorkoutConfig(
                day: .tuesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.back],
                routineTitle: "Day 2 - Back",
                customExercises: [
                    PDFExerciseFactory.pullUpsLatPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.barbellRow(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.chestSupportedRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.straightArmPulldown(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.reversePecDeck(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.dumbbellShrugs(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .wednesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.shoulders],
                routineTitle: "Day 3 - Shoulders",
                customExercises: [
                    PDFExerciseFactory.seatedDumbbellShoulderPress(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.dumbbellLateralRaises(sets: 4, reps: "12-20"),
                    PDFExerciseFactory.cableLateralRaises(sets: 2, reps: "12-20"),
                    PDFExerciseFactory.reversePecDeck(sets: 3, reps: "12-15"),
                    PDFExerciseFactory.facePulls(sets: 2, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .thursday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.biceps, .triceps, .forearms],
                routineTitle: "Day 4 - Arms",
                customExercises: [
                    PDFExerciseFactory.ezBarCurl(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.inclineDumbbellCurl(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.hammerCurl(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.closeGripBenchPress(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.tricepsRopePushdown(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.overheadCableTricepsExtension(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.wristCurlsOptional(sets: 2, reps: "12-20")
                ]
            ),
            DayWorkoutConfig(
                day: .friday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .hamstrings, .calves, .core],
                routineTitle: "Day 5 - Legs",
                customExercises: [
                    PDFExerciseFactory.barbellSquat(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.romanianDeadlift(sets: 3, reps: "8-10"),
                    PDFExerciseFactory.legPress(sets: 3, reps: "10-12"),
                    PDFExerciseFactory.seatedLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.legExtension(sets: 2, reps: "12-15"),
                    PDFExerciseFactory.standingCalfRaises(sets: 4, reps: "12-20"),
                    PDFExerciseFactory.cableCrunches(sets: 3, reps: "12-15")
                ]
            ),
            DayWorkoutConfig(
                day: .saturday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 6 - Weekend Rest",
                customExercises: []
            ),
            DayWorkoutConfig(
                day: .sunday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 7 - Weekend Rest",
                customExercises: []
            )
        ]
    }

    // 5. Full Body (3-Day) - Page 11
    public static var fullBodySchedule: [DayWorkoutConfig] {
        [
            DayWorkoutConfig(
                day: .monday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .chest, .back, .hamstrings, .shoulders, .biceps, .triceps],
                routineTitle: "Day 1 - Full Body A",
                customExercises: [
                    PDFExerciseFactory.barbellSquat(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.barbellBenchPress(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.latPulldown(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.romanianDeadlift(sets: 2, reps: "8-10"),
                    PDFExerciseFactory.dumbbellLateralRaises(sets: 2, reps: "12-20"),
                    PDFExerciseFactory.ezBarCurl(sets: 2, reps: "10-12"),
                    PDFExerciseFactory.tricepsPushdown(sets: 2, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .tuesday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 2 - Rest Day",
                customExercises: []
            ),
            DayWorkoutConfig(
                day: .wednesday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.hamstrings, .chest, .back, .quads, .shoulders, .biceps, .triceps, .calves],
                routineTitle: "Day 2 - Full Body B",
                customExercises: [
                    PDFExerciseFactory.romanianDeadlift(sets: 3, reps: "6-10"),
                    PDFExerciseFactory.inclineDumbbellPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.chestSupportedRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.bulgarianSplitSquat(sets: 2, reps: "8-12 per leg"),
                    PDFExerciseFactory.seatedDumbbellShoulderPress(sets: 2, reps: "8-12"),
                    PDFExerciseFactory.hammerCurl(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.overheadTricepsExtension(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.standingCalfRaises(sets: 2, reps: "12-20")
                ]
            ),
            DayWorkoutConfig(
                day: .thursday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 4 - Rest Day",
                customExercises: []
            ),
            DayWorkoutConfig(
                day: .friday,
                isRestDay: false,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [.quads, .chest, .back, .hamstrings, .shoulders, .biceps, .triceps, .core],
                routineTitle: "Day 3 - Full Body C",
                customExercises: [
                    PDFExerciseFactory.legPressHackSquat(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.machineChestPress(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.seatedCableRow(sets: 3, reps: "8-12"),
                    PDFExerciseFactory.seatedLegCurl(sets: 3, reps: "10-15"),
                    PDFExerciseFactory.cableLateralRaises(sets: 2, reps: "12-20"),
                    PDFExerciseFactory.preacherCurl(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.ropePushdown(sets: 2, reps: "10-15"),
                    PDFExerciseFactory.hangingKneeRaises(sets: 3, reps: "10-15")
                ]
            ),
            DayWorkoutConfig(
                day: .saturday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 6 - Weekend Rest",
                customExercises: []
            ),
            DayWorkoutConfig(
                day: .sunday,
                isRestDay: true,
                workoutTime: defaultTime,
                reminderMinutesBefore: 15,
                targetMuscles: [],
                routineTitle: "Day 7 - Weekend Rest",
                customExercises: []
            )
        ]
    }

    public static func schedule(for preset: SplitStore.PresetSplitType) -> [DayWorkoutConfig] {
        switch preset {
        case .pushPullLegs:
            return pushPullLegsSchedule
        case .arnoldSplit:
            return arnoldSplitSchedule
        case .upperLower:
            return upperLowerSchedule
        case .broSplit:
            return broSplitSchedule
        case .fullBody:
            return fullBodySchedule
        }
    }
}
