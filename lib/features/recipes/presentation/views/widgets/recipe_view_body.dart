import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_me_updated/core/widgets/shimmer_list.dart';
import 'package:track_me_updated/features/recipes/presentation/views/widgets/recipe_container_shimmer.dart';
import 'package:track_me_updated/features/recipes/presentation/views/widgets/recipe_list_view.dart';
import 'package:track_me_updated/features/recipes/presentation/bloc/fetch_recipes/fetch_recipes_cubit.dart';

class RecipeViewBody extends StatelessWidget {
  const RecipeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<FetchRecipesCubit, FetchRecipesState>(
          builder: (context, state) {
            if (state is FetchSearchRecipesSuccess) {
              if (state.recipes.isEmpty) {
                return Center(
                    child: Text(
                        "There are no recipes matching your search\n Try Searching for other recipes",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium));
              }
              return Expanded(
                child: RecipeListView(
                  recipes: state.recipes,
                ),
              );
            } else if (state is FetchRandomRecipesSuccess) {
              return Expanded(
                child: RecipeListView(
                  recipes: state.recipes,
                ),
              );
            } else if (state is FetchRandomRecipesError) {
              return Text(state.errMessage);
            } else {
              return const ShimmerList(
                child: RecipeContainerShimmer(),
              );
            }
          },
        )
      ],
    );
  }
}
