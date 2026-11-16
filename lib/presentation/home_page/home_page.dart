import 'package:first_flutter_project/domain/models/card.dart';
import 'package:first_flutter_project/presentation/like_bloc/like_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/presentation/details_page/details_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_flutter_project/presentation/home_page/bloc/bloc.dart';
import 'package:first_flutter_project/presentation/home_page/bloc/state.dart';
import 'package:first_flutter_project/presentation/home_page/bloc/events.dart';
import 'package:first_flutter_project/components/utils/debounce.dart';
import 'package:first_flutter_project/presentation/common/svg_objects.dart';
import 'package:first_flutter_project/components/locale/l10n/app_locale.dart';
import 'package:first_flutter_project/components/extensions/context_x.dart';

import 'package:first_flutter_project/presentation/locale_bloc/locale_bloc.dart';
import 'package:first_flutter_project/presentation/locale_bloc/locale_events.dart';
import 'package:first_flutter_project/presentation/locale_bloc/locale_state.dart';

import 'package:first_flutter_project/presentation/like_bloc/like_bloc.dart';
import 'package:first_flutter_project/presentation/like_bloc/like_state.dart';

part 'card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _color = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _color,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SvgObjects.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadDataEvent(search: 'man'));
      context.read<LikeBloc>().add(const LoadLikesEvent());
    });
    scrollController.addListener(_onNextPageListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onNextPageListener);
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onNextPageListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      final bloc = context.read<HomeBloc>();

      if (!bloc.state.isPaginationLoading && !bloc.state.isLoading) {
        final currentLength = bloc.state.data?.length ?? 0;
        final nextPage = (currentLength ~/ 10) + 1;

        bloc.add(HomeLoadDataEvent(
          search: searchController.text,
          nextPage: nextPage,
        ));
      }
    }
  }

  void _showSnackBar(BuildContext context, String title, bool isLiked) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Film "$title" ${isLiked ? context.locale.liked : context.locale.disliked}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    placeholder: context.locale.search,
                    placeholderStyle: const TextStyle(color: Colors.amber),
                    prefixIcon: const Icon(CupertinoIcons.search, color: Colors.amber),
                    style: const TextStyle(color: Colors.amber),
                    onChanged: (search) {
                      if (search.trim().isEmpty) {
                        Debounce.run(() {});
                        context.read<HomeBloc>().add(const HomeLoadDataEvent(search: 'man'));
                        return;
                      }
                      Debounce.run(() => context.read<HomeBloc>().add(HomeLoadDataEvent(search: search)));
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.read<LocaleBloc>().add(const ChangeLocaleEvent()),
                child: SizedBox.square(
                  dimension: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: BlocBuilder<LocaleBloc, LocaleState>(
                      builder: (context, state) {
                        return state.currentLocale.languageCode == 'ru'
                            ? const SvgRu()
                            : const SvgUk();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.error != null
                ? Text(
              state.error ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),
            )
                : state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : BlocBuilder<LikeBloc, LikeState>(
              builder: (context, likeState) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: (state.data?.length ?? 0) + (state.isPaginationLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == (state.data?.length ?? 0) && state.isPaginationLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator(color: Colors.amber)),
                          );
                        }

                        final data = state.data?[index];
                        return data != null
                            ? _Card.fromData(
                          data,
                          onLike: _onLike,
                          isLiked: likeState.likedIds?.contains(data.imdbId) ?? false,
                          onTap: () => _navToDetails(context, data),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onLike(String? id, String title, bool isLiked) {
    if (id != null) {
      context.read<LikeBloc>().add(ChangeLikeEvent(id));
      _showSnackBar(context, title, !isLiked); //т.к. мы только что переключили isLiked
    }
  }

  Future<void> _onRefresh() {
    context.read<HomeBloc>().add(HomeLoadDataEvent(search: searchController.text));
    return Future.value(null);
  }

  void _navToDetails(BuildContext context, CardData data) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailsPage(data)),
    );
  }
}