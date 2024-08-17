import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:track_me_updated/core/widgets/shimmer_list.dart';
import 'package:track_me_updated/features/exercises/data/models/exercise_model/exercise_model.dart';
import 'package:track_me_updated/features/exercises/presentation/views/widgets/exercise_container.dart';
import 'package:track_me_updated/features/exercises/presentation/views/widgets/exercise_container_shimmer.dart';
import 'package:track_me_updated/features/workout/presentation/bloc/workout_exercise_cubit/workout_exercise_cubit.dart';
import 'package:track_me_updated/features/workout/presentation/views/single_workout_view.dart';

class WorkoutPlanExercises extends StatefulWidget {
  final int dayId;
  const WorkoutPlanExercises({super.key, required this.dayId});

  @override
  State<WorkoutPlanExercises> createState() => _WorkoutPlanExercisesState();
}

class _WorkoutPlanExercisesState extends State<WorkoutPlanExercises> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutExerciseCubit>().loadWorkoutExercises(widget.dayId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutExerciseCubit, WorkoutExerciseState>(
      builder: (context, state) {
        if (state is WorkoutExerciseSuccess) {
          if (state.exercises.isEmpty) {
            return Center(
              child: Text(
                "Start Adding Exercises to your workout",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => pushScreen(context,
                      withNavBar: true,
                      screen: SingleWorkoutView(
                          exerciseModel: ExerciseModel(
                              id: state.exercises[index].id.toString(),
                              bodyPart: state.exercises[index].bodyPart,
                              gifUrl: state.exercises[index].gifUrl,
                              name: state.exercises[index].exerciseName,
                              target: state.exercises[index].target,
                              secondaryMuscles: state
                                  .exercises[index].secondaryMuscles
                                  .split(',')
                                  .toList(),
                              instructions:
                                  state.exercises[index].instructions))),
                  child: ExerciseContainer(
                    bodyPart: state.exercises[index].bodyPart,
                    exerciseGifUrl: state.exercises[index].gifUrl,
                    title: state.exercises[index].exerciseName,
                    targets: state.exercises[index].target,
                    secondaryMuscles: state.exercises[index].secondaryMuscles,
                  ),
                );
              },
              itemCount: state.exercises.length,
            );
          }
        } else if (state is WorkoutExerciseError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const ShimmerList(
            child: ExerciseContainerShimmer(),
          );
        }
      },
    );
  }
}
