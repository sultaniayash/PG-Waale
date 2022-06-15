import 'package:flutter/material.dart';
import 'package:qbix/components/buttons_component.dart';
import 'package:qbix/screens/words/word_detail_screen.dart';
import 'package:qbix/screens/words/word_model.dart';
import 'package:qbix/screens/words/word_service.dart';
import 'package:qbix/theme/app_colors.dart';
import 'package:qbix/theme/textstyles.dart';
import 'package:qbix/utils/a_utils.dart';

class WordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WordModel>(
      future: WordService.getTodayWord(context),
      builder: (context, snapshot) {
        if (snapshot.data.id.isNotEmpty) {
          WordModel wordModel = snapshot.data;
          return Container(
            margin: EdgeInsets.all(Sizes.s10),
            padding: EdgeInsets.all(Sizes.s10),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Sizes.s8),
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 0.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: Sizes.s10,
                    spreadRadius: -Sizes.s6,
                    offset: Offset(0, 2),
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                C10(),
                Text(
                  dateDOBFormatter.format(DateTime.now()),
                  style: TextStyles.defaultRegular.copyWith(
                    color: Colors.red.shade300,
                  ),
                ),
                Container(
                  height: Sizes.s100,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "${wordModel.word}",
                      style: TextStyles.defaultSemiBold.copyWith(
                        fontSize: FontSize.s20,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (wordModel.definitions.isNotEmpty)
                  Text(
                    "definition",
                    style: TextStyles.defaultRegular.copyWith(
                      fontSize: FontSize.s12,
                    ),
                  ),
                C5(),
                if (wordModel.definitions.isNotEmpty)
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.all(Sizes.s12),
                    child: Text(
                      "${wordModel.definitions.first.text}",
                      style: TextStyles.defaultItalic.copyWith(
                        color: Colors.red.shade600,
                        fontSize: FontSize.s14,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  )),
                TextButton(
                  onTap: () {
                    AppRoutes.push(context, WordDetailScreen(word: wordModel));
                  },
                  text: "View Examples And More Details",
                  textStyle: TextStyles.defaultSemiBold.copyWith(
                    fontSize: FontSize.s12,
                    color: AppColors.primary,
                  ),
                  padding: EdgeInsets.all(Sizes.s5),
                ),
              ],
            ),
          );
        }

        return Center(child: LoadingWidget());
      },
      initialData: WordModel.empty(),
    );
  }
}
