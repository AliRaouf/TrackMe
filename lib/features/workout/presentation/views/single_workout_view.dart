import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:track_me_updated/core/styles.dart';
import 'package:track_me_updated/core/theme/themes.dart';
import 'package:track_me_updated/features/exercises/data/models/exercise_model/exercise_model.dart';
import 'package:track_me_updated/features/exercises/presentation/views/widgets/single_exercise_view_body.dart';
import 'package:track_me_updated/features/workout/presentation/bloc/workout_exercise_cubit/workout_exercise_cubit.dart';

class SingleWorkoutView extends StatelessWidget {
  const SingleWorkoutView({super.key, required this.exerciseModel});
  final ExerciseModel exerciseModel;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).brightness == Brightness.dark
          ? workoutTrackerDarkTheme
          : workoutTrackerLightTheme,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<WorkoutExerciseCubit, WorkoutExerciseState>(
              builder: (context, state) {
                if (state is WorkoutExerciseSuccess) {
                  return IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Workout'),
                            content: const Text(
                                'Are you sure you want to delete this Workout?'),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Delete',
                                      style: TextStyles.cta18,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<WorkoutExerciseCubit>()
                                          .deleteWorkoutExercise(
                                              int.parse(exerciseModel.id!));
                                      context.pushReplacement(
                                          '/workout/workout_plan');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_rounded),
                    color: Colors.white,
                  );
                } else if (state is WorkoutExerciseError) {
                  return const Icon(Icons.error);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
          title: Text(exerciseModel.name ?? "", style: TextStyles.title22Dark),
          centerTitle: true,
        ),
        body: SingleExerciseViewBody(exerciseModel: exerciseModel),
      ),
    );
  }
}
