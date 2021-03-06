import 'package:flutter/material.dart';

const USERLEVEL = {
  'participant': {
    'level': 'deelnemer',
    'gameVariable': 'participants',
    'gameQueryCondition': 'array-contains',
    'userVariable': 'participating'
  },
  'player': {
    'level': 'speler',
    'gameVariable': 'players',
    'gameQueryCondition': 'array-contains',
    'userVariable': 'playing'
  },
  'judge': {
    'level': 'jurylid',
    'gameVariable': 'judges',
    'gameQueryCondition': 'array-contains',
    'userVariable': 'judging'
  },
  'administrator': {
    'level': 'beheerder',
    'gameVariable': 'administrator',
    'gameQueryCondition': '==',
    'userVariable': 'administrating'
  }
};

const GAME_NAMES = [
  'Turn around and take a selfie',
  'Do you wanna selfie?',
  'Hey, that\'s my selfie',
  'Selfies are my life',
  'Live life the selfie way',
  'Take it easy, take a selfie',
  'Selfie is the Game you play',
  'Play the game selfie me',
  'Selfie you selfie me',
  'Can I take a selfie with you?',
  'Selfies everywhere',
  'Come with me on a selfie tour',
  'Live the selfie way',
  'Watch my selfie',
  'It\'s not easy being a selfie',
  'Always look on the selfie side of life'
];

const GAME_IMAGES = [
  'standaard/selfie3.png',
  'standaard/selfiestick.png',
  'standaard/selfie-strand.png',
  'standaard/selfie-recht.png',
  'standaard/selfie-strand2.png',
  'standaard/selfie-baard.png',
  'standaard/selfie-bitch.png',
  'standaard/Hoedje.png',
  'standaard/selfie-achter.png',
  'standaard/selfie-recht2.png'
];

const List<Map<String, dynamic>> ASSIGNMENTS = [
  {
    'assignment': 'iets wat rolt',
    'isOutside': false,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'een tuinkabouter',
    'isOutside': true,
    'level': 2,
    'maxPoints': 3
  },
  {
    'assignment': 'iets wat geluid maakt',
    'isOutside': false,
    'level': 1,
    'maxPoints': 1
  },
  {'assignment': 'iets roods', 'isOutside': false, 'level': 1, 'maxPoints': 1},
  {'assignment': 'iets blauws', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {'assignment': 'iets paars', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {'assignment': 'een dier', 'isOutside': true, 'level': 1, 'maxPoints': 1},
  {'assignment': 'een eend', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {'assignment': 'een gans', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {
    'assignment': 'iets wat stinkt',
    'isOutside': false,
    'level': 1,
    'maxPoints': 1
  },
  {'assignment': 'zwerfvuil', 'isOutside': true, 'level': 1, 'maxPoints': 1},
  {'assignment': 'papier', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {
    'assignment': 'iets om mee te schrijven',
    'isOutside': false,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'een spinnenweb',
    'isOutside': true,
    'level': 3,
    'maxPoints': 5
  },
  {'assignment': 'brandnetels', 'isOutside': true, 'level': 2, 'maxPoints': 3},
  {'assignment': 'mos', 'isOutside': true, 'level': 1, 'maxPoints': 1},
  {'assignment': 'nummer 14', 'isOutside': false, 'level': 1, 'maxPoints': 1},
  {'assignment': 'nummer 123', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {'assignment': 'nummer 2a', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {'assignment': 'fruit', 'isOutside': false, 'level': 1, 'maxPoints': 1},
  {'assignment': 'appel', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {'assignment': 'besjes', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {
    'assignment': 'een wandelpad paal',
    'isOutside': true,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'een voorrangsbord',
    'isOutside': true,
    'level': 2,
    'maxPoints': 3
  },
  {
    'assignment': 'een bord doodlopende weg',
    'isOutside': true,
    'level': 3,
    'maxPoints': 5
  },
  {'assignment': 'iets groots', 'isOutside': false, 'level': 1, 'maxPoints': 1},
  {'assignment': 'iets glads', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {'assignment': 'iets ruws', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {'assignment': 'een hoed', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {
    'assignment': 'met zonder jas',
    'isOutside': false,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'met bril (niet van jezelf)',
    'isOutside': false,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'iemand die een hond uitlaat',
    'isOutside': true,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'een kinderwagen',
    'isOutside': true,
    'level': 2,
    'maxPoints': 3
  },
  {'assignment': 'een step', 'isOutside': true, 'level': 3, 'maxPoints': 5},
  {
    'assignment': 'een dure auto',
    'isOutside': true,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'een auto met een buitenlands kenteken',
    'isOutside': true,
    'level': 2,
    'maxPoints': 3
  },
  {
    'assignment': 'een speelgoedauto',
    'isOutside': true,
    'level': 3,
    'maxPoints': 5
  },
  {'assignment': 'een toren', 'isOutside': true, 'level': 2, 'maxPoints': 3},
  {
    'assignment': 'een schoolgebouw',
    'isOutside': true,
    'level': 1,
    'maxPoints': 1
  },
  {'assignment': 'een vlag', 'isOutside': true, 'level': 3, 'maxPoints': 5},
  {
    'assignment': 'de krant van gisteren',
    'isOutside': false,
    'level': 2,
    'maxPoints': 3
  },
  {
    'assignment': 'iets eetbaars',
    'isOutside': false,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'een instrument',
    'isOutside': false,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'een wandelstok',
    'isOutside': false,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'een vogelhuisje',
    'isOutside': true,
    'level': 1,
    'maxPoints': 1
  },
  {
    'assignment': 'iets glimmends',
    'isOutside': false,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'iets van hout',
    'isOutside': false,
    'level': 2,
    'maxPoints': 3
  },
  {
    'assignment': 'een uithangbord',
    'isOutside': true,
    'level': 2,
    'theme': 'mall',
    'maxPoints': 3
  },
  {'assignment': 'een rugtas', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {
    'assignment': 'een eetkraampje',
    'isOutside': true,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'een gele auto',
    'isOutside': true,
    'level': 3,
    'maxPoints': 5
  },
  {
    'assignment': 'iets te drinken',
    'isOutside': false,
    'level': 1,
    'maxPoints': 1
  },
  {'assignment': 'een bal', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {'assignment': 'een sport', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {'assignment': 'iets breeds', 'isOutside': false, 'level': 3, 'maxPoints': 5},
  {'assignment': 'iets hoogs', 'isOutside': false, 'level': 2, 'maxPoints': 3},
  {
    'assignment': 'een etalagepop',
    'isOutside': false,
    'level': 1,
    'theme': 'mall',
    'maxPoints': 1
  },
  {
    'assignment': 'een lift',
    'isOutside': false,
    'level': 2,
    'theme': 'mall',
    'maxPoints': 3
  },
  {
    'assignment': 'een roltrap',
    'isOutside': false,
    'level': 3,
    'theme': 'mall',
    'maxPoints': 5
  },
  {
    'assignment': 'nooduitgang bordje',
    'isOutside': false,
    'level': 2,
    'theme': 'mall',
    'maxPoints': 3
  },
  {
    'assignment': 'bewakingscamera',
    'isOutside': false,
    'level': 3,
    'theme': 'mall',
    'maxPoints': 5
  },
  {
    'assignment': 'een kerstman',
    'isOutside': false,
    'level': 1,
    'theme': 'christmas',
    'maxPoints': 1
  },
  {
    'assignment': 'kerstlichtjes',
    'isOutside': false,
    'level': 3,
    'theme': 'christmas',
    'maxPoints': 5
  },
  {
    'assignment': 'een kerstbal',
    'isOutside': false,
    'level': 2,
    'theme': 'christmas',
    'maxPoints': 3
  },
];

const TEAM_NAMES = [
  'TeamSelfie',
  'Selfie4Life',
  'I<3Selfie',
  'Selfie4Ever',
  'SuperSelfie',
  'De Selfies',
  'SuperDuperSelfies',
  'SunnySelfie',
  'SelfieIt',
  'SeeMySelfie',
  'TheBestSelfieMakers',
  'HappySelfieMakers',
  'TrueSelfies',
  'KardashianSelfies',
  'BeMySelfie',
  'HelloSelfies',
  'TheOnlySelfies',
  'WeLoveSelfies',
  'TakeMySelfie',
];

const List<Map<String, dynamic>> TEAM_COLORS = [
  {'color': "#F44336", 'colorLabel': "Rood"},
  {'color': "#E91E63", 'colorLabel': "Roze"},
  {'color': "#9C27B0", 'colorLabel': "Paars"},
  {'color': "#673AB7", 'colorLabel': "Donkerpaars"},
  {'color': "#3F51B5", 'colorLabel': "Indigo"},
  {'color': "#2196F3", 'colorLabel': "Blauw"},
  {'color': "#03A9F4", 'colorLabel': "Lichtblauw"},
  {'color': "#00BCD4", 'colorLabel': "Cyaan"},
  {'color': "#009688", 'colorLabel': "Blauwgroen"},
  {'color': "#4CAF50", 'colorLabel': "Groen"},
  {'color': "#8BC34A", 'colorLabel': "Lichtgroen"},
  {'color': "#CDDC39", 'colorLabel': "Limoen"},
  {'color': "#FFEB3B", 'colorLabel': "Geel"},
  {'color': "#FFC107", 'colorLabel': "Amber"},
  {'color': "#FF9800", 'colorLabel': "Oranje"},
  {'color': "#FF5722", 'colorLabel': "Oranjerood"},
  {'color': "#795548", 'colorLabel': "Bruin"},
  {'color': "#9E9E9E", 'colorLabel': "Grijs"},
  {'color': "#607D8B", 'colorLabel': "Blauwgrijs"}
];


MaterialColor primaryColorShades = const MaterialColor(
  0xFF040046, //donkerblauw
  const {
    50: Color(0xFFD2FFD4), //lichtgroen
    100: Color(0xFF040046),
    200: Color(0xFF040046),
    300: Color(0xFF040046),
    400: Color(0xFF040046),
    500: Color(0xFF040046),
    600: Color(0xFF040046),
    700: Color(0xFF040046),
    800: Color(0xFF040046),
    900: Color(0xFF040046),
  },
);
MaterialColor accentColorShades = const MaterialColor(
  0xFF86FFCB, //groen
  const {
    50: Color(0xFFD2FFD4),
    100: Color(0xFF86FFCB),
    200: Color(0xFF86FFCB),
    300: Color(0xFF86FFCB),
    400: Color(0xFF86FFCB),
    500: Color(0xFF86FFCB),
    600: Color(0xFF86FFCB),
    700: Color(0xFF86FFCB),
    800: Color(0xFF86FFCB),
    900: Color(0xFF86FFCB),
  },
);
