// import 'package:hetu_script/binding.dart';
// import 'package:hetu_script/hetu_script.dart';
//
// import 'element.dart';
//
// extension LazyElementBinding on LazyElement {
//   dynamic htFetch(String varName) {
//     switch (varName) {
//       case 'text':
//         return text;
//       case 'name':
//         return name;
//       case 'add':
//         return (HTEntity entity,
//                 {List<dynamic> positionalArgs = const [],
//                 Map<String, dynamic> namedArgs = const {},
//                 List<HTType> typeArgs = const []}) =>
//             add(positionalArgs.first, Hetu());
//       case 'child':
//         return child;
//       default:
//         throw HTError.undefined(varName);
//     }
//   }
//
//   void htAssign(String varName, dynamic varValue) {
//     switch (varName) {
//       case 'name':
//         name = varValue;
//         break;
//       case 'text':
//         text = varValue;
//         break;
//       default:
//         throw HTError.undefined(varName);
//     }
//   }
// }
//
// class LazyElementClassBinding extends HTExternalClass {
//   LazyElementClassBinding() : super('LazyElement');
//
//   @override
//   dynamic memberGet(String varName, {String? from}) {
//     switch (varName) {
//       // case 'LazyElement':
//       //   return (HTEntity entity,
//       //       {List<dynamic> positionalArgs = const [],
//       //         Map<String, dynamic> namedArgs = const {},
//       //         List<HTType> typeArgs = const []}) =>
//       //       LazyElement(positionalArgs[0], positionalArgs[1]);
//       // case 'LazyElement.withName':
//       //   return (HTEntity entity,
//       //       {List<dynamic> positionalArgs = const [],
//       //         Map<String, dynamic> namedArgs = const {},
//       //         List<HTType> typeArgs = const []}) =>
//       //       LazyElement.withName(positionalArgs[0],
//       //           (positionalArgs.length > 1 ? positionalArgs[1] : 'Caucasion'));
//       // case 'LazyElement.meaning':
//       //   return (HTEntity entity,
//       //       {List<dynamic> positionalArgs = const [],
//       //         Map<String, dynamic> namedArgs = const {},
//       //         List<HTType> typeArgs = const []}) =>
//       //       LazyElement.meaning(positionalArgs[0]);
//       // case 'LazyElement.level':
//       //   return LazyElement.level;
//       default:
//         throw HTError.undefined(varName);
//     }
//   }
//
//   @override
//   void memberSet(String varName, dynamic varValue, {String? from}) {
//     switch (varName) {
//       // case 'LazyElement.race':
//       //   throw HTError.immutable(varName);
//       // case 'LazyElement.level':
//       //   LazyElement.level = varValue;
//       //   break;
//       default:
//         throw HTError.undefined(varName);
//     }
//   }
//
//   @override
//   dynamic instanceMemberGet(dynamic object, String varName) {
//     var i = object as LazyElement;
//     return i.htFetch(varName);
//   }
//
//   @override
//   void instanceMemberSet(dynamic object, String varName, dynamic varValue) {
//     var i = object as LazyElement;
//     i.htAssign(varName, varValue);
//   }
// }
// //
// // void main() {
// //   final hetu = Hetu();
// //   hetu.init(externalClasses: [LazyElementClassBinding()]);
// //   hetu.eval('''
// //       external class LazyElement {
// //         var race: str
// //         construct([name: str = 'Jimmy', race: str = 'Caucasian']);
// //         get child
// //         static fun meaning(n: num)
// //         static get level
// //         static set level (value: str)
// //         construct withName(name: str, [race: str = 'Caucasian'])
// //         var name
// //         fun greeting(tag: str)
// //       }
// //       var p1: LazyElement = LazyElement()
// //       p1.greeting('jimmy')
// //       print(LazyElement.meaning(42))
// //       print(typeof p1)
// //       print(p1.name)
// //       print(p1.child)
// //       print('My race is', p1.race)
// //       p1.race = 'Reptile'
// //       print('Oh no! My race turned into', p1.race)
// //       LazyElement.level = '3'
// //       print(LazyElement.level)
// //       var p2 = LazyElement.withName('Jimmy')
// //       print(p2.name)
// //       p2.name = 'John'
// //       ''');
// // }
