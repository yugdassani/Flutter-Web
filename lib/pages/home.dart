// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/layout/adaptive.dart';
import 'package:gallery/pages/experience_list_item.dart';

const _horizontalPadding = 32.0;
const _carouselItemMargin = 8.0;
const _horizontalDesktopPadding = 81.0;
const _carouselHeightMin = 200.0 + 2 * _carouselItemMargin;
const _desktopCardsPerPage = 4;

class ToggleSplashNotification extends Notification {}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var carouselHeight = _carouselHeight(.7, context);
    final isDesktop = isDisplayDesktop(context);

    final experienceItems = <_ExperienceItem>[
      const _ExperienceItem(jobTitle: enVistaJobTitle,company: enVistaCompany, duration: enVistaDuration, details: enVistaDetails),
      const _ExperienceItem(jobTitle: EYJobTitle,company: EYCompany, duration: EYDuration, details: EYDetails),
      const _ExperienceItem(jobTitle: mphasisJobTitle,company: mphasisCompany, duration: mphasisDuration, details: mphasisDetails)
    ];

    final projectItems = <_ProjectItem>[
      const _ProjectItem(title: 'GetTogether',asset: AssetImage(getTogetherLogo),details: getTogetherDetails),
      const _ProjectItem(title: 'Incubator',asset: AssetImage(incubatorLogo),details: incubatorDetails),
    ];

    return Scaffold(
      body: ListView(
        // Makes integration tests possible.
        key: const ValueKey('HomeListView'),
        padding: EdgeInsetsDirectional.only(
          top: isDesktop ? firstHeaderDesktopTopPadding : 21,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalDesktopPadding,
            ),
            child: _AboutHeader(),
          ),
          SizedBox(
            height: carouselHeight * 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalDesktopPadding),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage(profilePath),
                    radius: 200,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 5
                        ),
                        child: SelectableText(
                          introText,
                          style: Theme.of(context).textTheme.headline4?.apply(
                          color: Colors.white,
                          fontSizeDelta: isDisplayDesktop(context) ? 16 : 0)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 1,
                            bottom: 5
                        ),
                        child: SelectableText(
                            introSubText,
                            style: Theme.of(context).textTheme.headline4?.apply(
                                color: Colors.grey,
                                fontSizeDelta: isDisplayDesktop(context) ? 6 : 0)
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalDesktopPadding,
            ),
            child: _ExperienceHeader(),
          ),
          Container(
            height: 750,
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalDesktopPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: verticalSpaceBetween(28, experienceItems),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalDesktopPadding,
            ),
            child: _ProjectHeader(),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalDesktopPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: horizontalSpaceBetween(28, projectItems),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: _horizontalDesktopPadding,
              bottom: 81,
              end: _horizontalDesktopPadding,
              top: 109,
            ),
            child: Row(
              /**children: [
                FadeInImagePlaceholder(
                  image: Theme.of(context).colorScheme.brightness ==
                          Brightness.dark
                      ? const AssetImage(
                          'assets/logo/flutter_logo.png',
                          package: 'flutter_gallery_assets',
                        )
                      : const AssetImage(
                          'assets/logo/flutter_logo_color.png',
                          package: 'flutter_gallery_assets',
                        ),
                  placeholder: const SizedBox.shrink(),
                  excludeFromSemantics: true,
                ),
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: const [
                      SettingsAbout(),
                      SettingsFeedback(),
                    ],
                  ),
                ),
              ],*/
            ),
          ),
        ],
      ),
    );

  }

  List<Widget> verticalSpaceBetween(double paddingBetween, List<Widget> children) {
    return [
      for (int index = 0; index < children.length; index++) ...[
        Flexible(
          child: children[index],
        ),
        if (index < children.length - 1) SizedBox(height: paddingBetween),
      ],
    ];
  }

  List<Widget> horizontalSpaceBetween(double paddingBetween, List<Widget> children) {
    return [
      for (int index = 0; index < children.length; index++) ...[
        Flexible(
          child: children[index],
        ),
        if (index < children.length - 1) SizedBox(width: paddingBetween),
      ],
    ];
  }
}

class _AboutHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primaryContainer,
      text: 'About Me',
    );
  }
}

class _ExperienceHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primary,
      text: 'Experience',
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primaryContainer,
      text: 'Projects',
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key key, this.color, this.text}) : super(key: key);

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isDisplayDesktop(context) ? 63 : 15,
        bottom: isDisplayDesktop(context) ? 21 : 11,
      ),
      child: SelectableText(
        text,
        style: Theme.of(context).textTheme.headline4.apply(
              color: color,
              fontSizeDelta:
                  isDisplayDesktop(context) ? desktopDisplay1FontDelta : 0,
            ),
      ),
    );
  }
}


class _ExperienceItem extends StatelessWidget{
  const _ExperienceItem({
    this.jobTitle,
    this.company,
    this.duration,
    this.details,
  });

  final String jobTitle;
  final String company;
  final String duration;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      child: Semantics(
        container: true,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Column(
            children: [
              _ExperienceIndHeader(jobTitle: jobTitle,
                  company: company,
                  duration: duration),
              Divider(
                height: 2,
                thickness: 2,
                color: colorScheme.background,
              ),
              Flexible(
                child: ListView.builder(
                  // Makes integration tests possible.
                  key: ValueKey('${company}detailList'),
                  itemBuilder: (context, index) =>
                      ExperienceListItem(detail: details[index]),
                  itemCount: details.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExperienceIndHeader extends StatelessWidget {
  const _ExperienceIndHeader({
    this.jobTitle,
    this.company,
    this.duration
  });

  final String jobTitle;
  final String company;
  final String duration;

  @override
  Widget build(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      // Makes integration tests possible.
      key: ValueKey('${company}CategoryHeader'),
      color: colorScheme.onBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SelectableText(
              jobTitle+' @ '+company,
              style: Theme.of(context).textTheme.headline5.apply(
                color: colorScheme.onSurface,
              )
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 15),
              child: Semantics(
                header: true,
                child: SelectableText(
                  duration,
                  style: Theme.of(context).textTheme.headline5.apply(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _ProjectItem extends StatelessWidget{
  const _ProjectItem({
    this.title,
    this.asset,
    this.details,
  });

  final String title;
  final AssetImage asset;
  final String details;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface,
      child: Semantics(
        container: true,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Column(
              children: [
                _ProjectIndHeader(title: title),
                Divider(
                  height: 2,
                  thickness: 2,
                  color: colorScheme.background,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 32,
                      top: 20,
                      end: isDisplayDesktop(context) ? 16 : 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                         CircleAvatar(
                           backgroundColor: Colors.transparent,
                          backgroundImage: asset,
                          radius: 40,
                        ),
                        Text(
                          details,
                          style: Theme.of(context).textTheme.subtitle1.apply(color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}

class _ProjectIndHeader extends StatelessWidget {
  const _ProjectIndHeader({
    this.title,
  });

  final String title;


  @override
  Widget build(BuildContext context){
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      // Makes integration tests possible.
      key: ValueKey('${title}CategoryHeader'),
      color: colorScheme.onBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SelectableText(
                title,
                style: Theme.of(context).textTheme.headline5.apply(
                  color: colorScheme.onSurface,
                )
            ),
          ),
        ],
      ),
    );
  }
}


double _carouselHeight(double scaleFactor, BuildContext context) => math.max(
    _carouselHeightMin *
        GalleryOptions.of(context).textScaleFactor(context) *
        scaleFactor,
    _carouselHeightMin);

/// Wrap the studies with this to display a back button and allow the user to
/// exit them at any time.
class StudyWrapper extends StatefulWidget {
  const StudyWrapper({
    Key key,
    this.study,
    this.alignment = AlignmentDirectional.bottomStart,
    this.hasBottomNavBar = false,
  }) : super(key: key);

  final Widget study;
  final bool hasBottomNavBar;
  final AlignmentDirectional alignment;

  @override
  _StudyWrapperState createState() => _StudyWrapperState();
}

class _StudyWrapperState extends State<StudyWrapper> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ApplyTextOptions(
      child: Stack(
        children: [
          Semantics(
            sortKey: const OrdinalSortKey(1),
            child: RestorationScope(
              restorationId: 'study_wrapper',
              child: widget.study,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: widget.alignment,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: widget.hasBottomNavBar
                        ? kBottomNavigationBarHeight + 16.0
                        : 16.0),
                child: Semantics(
                  sortKey: const OrdinalSortKey(0),
                  label: GalleryLocalizations.of(context).backToGallery,
                  button: true,
                  enabled: true,
                  excludeSemantics: true,
                  child: FloatingActionButton.extended(
                    heroTag: _BackButtonHeroTag(),
                    key: const ValueKey('Back'),
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((route) => route.settings.name == '/');
                    },
                    icon: IconTheme(
                      data: IconThemeData(color: colorScheme.onPrimary),
                      child: const BackButtonIcon(),
                    ),
                    label: Text(
                      MaterialLocalizations.of(context).backButtonTooltip,
                      style:
                          textTheme.button.apply(color: colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButtonHeroTag {}
