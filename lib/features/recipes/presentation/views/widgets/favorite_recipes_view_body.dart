import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:track_me_updated/core/widgets/shimmer_list.dart';
import 'package:track_me_updated/features/recipes/presentation/bloc/favorite_recipes/favorite_recipes_cubit.dart';
import 'package:track_me_updated/features/recipes/presentation/views/selected_favorite_recipe_view.dart';
import 'package:track_me_updated/features/recipes/presentation/views/widgets/recipe_container.dart';
import 'package:track_me_updated/features/recipes/presentation/views/widgets/recipe_container_shimmer.dart';

class FavoriteRecipesViewBody extends StatelessWidget {
  const FavoriteRecipesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteRecipesCubit, FavoriteRecipesState>(
      builder: (context, state) {
        if (state is FavoriteRecipesSuccess) {
          if (state.recipes.isNotEmpty) {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => pushScreen(context,
                        screen: SelectedFavoriteRecipeView(
                          favoriteRecipeModel: state.recipes[index],
                        ),
                        withNavBar: true),
                    child: RecipeContainer(
                      title: state.recipes[index].title,
                      readyIn: state.recipes[index].readyIn,
                      id: state.recipes[index].recipeID,
                      servings: state.recipes[index].serving,
                    ),
                  );
                },
                itemCount: state.recipes.length);
          } else {
            return const Center(
              child: Text("No favorite recipes added yet"),
            );
          }
        } else if (state is FavoriteRecipesLoading) {
          return const ShimmerList(
            child: RecipeContainerShimmer(),
          );
        } else {
          return const Center(
            child: Text("Start Adding Recipes to your favorites"),
          );
        }
      },
    );
  }
}
