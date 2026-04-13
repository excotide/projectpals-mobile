import 'package:flutter/material.dart';
class Onboarding3 extends StatefulWidget {
	const Onboarding3({super.key});
	@override
	Onboarding3State createState() => Onboarding3State();
}
class Onboarding3State extends State<Onboarding3> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										color: Color(0xFF041329),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											padding: const EdgeInsets.only( bottom: 12),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															color: Color(0x00000000),
															padding: const EdgeInsets.symmetric(vertical: 26),
															width: double.infinity,
															child: Column(
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.symmetric(horizontal: 26),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Text(
																						"08:48",
																						style: TextStyle(
																							color: Color(0xFFFFFFFF),
																							fontSize: 16,
																						),
																					),
																					Expanded(
																						child: SizedBox(
																							width: double.infinity,
																							child: SizedBox(),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( right: 7),
																						width: 15,
																						height: 10,
																						child: SizedBox(),
																					),
																					Container(
																						margin: const EdgeInsets.only( right: 6),
																						width: 16,
																						height: 11,
																						child: Image.network(
																							"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/b772c6c7-4523-409a-b731-65a522c9241f",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									border: Border.all(
																										color: Color(0xFFFFFFFF),
																										width: 1,
																									),
																								),
																								padding: const EdgeInsets.all(2),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											color: Color(0xFFFFFFFF),
																											width: 12,
																											height: 7,
																											child: SizedBox(),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xFF041329),
																			padding: const EdgeInsets.only( top: 10, bottom: 10, left: 16, right: 16),
																			margin: const EdgeInsets.only( bottom: 42),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					SizedBox(
																						width: 16,
																						height: 16,
																						child: Image.network(
																							"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/29dbedfb-0dcb-4e9f-a3f1-c4d7f340c208",
																							fit: BoxFit.fill,
																						)
																					),
																					Text(
																						"PROJECTPALS",
																						style: TextStyle(
																							color: Color(0xFFD6E3FF),
																							fontSize: 18,
																							fontWeight: FontWeight.bold,
																						),
																					),
																					SizedBox(
																						width: 16,
																						height: 16,
																						child: SizedBox(),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				border: Border(
																					top: BorderSide(
																						color: Color(0x333CD7FF),
																						width: 1,
																					),
																				),
																				borderRadius: BorderRadius.circular(12),
																				color: Color(0x9927354C),
																			),
																			padding: const EdgeInsets.all(32),
																			margin: const EdgeInsets.only( bottom: 48, left: 32, right: 32),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 24),
																							width: double.infinity,
																							child: Row(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 8),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															margin: const EdgeInsets.only( bottom: 4),
																															height: 16,
																															width: double.infinity,
																															child: SizedBox(),
																														),
																														IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.symmetric(vertical: 7),
																																width: double.infinity,
																																child: Column(
																																	children: [
																																		Text(
																																			"PITSTOP PROJECT",
																																			style: TextStyle(
																																				color: Color(0xFFD6E3FF),
																																				fontSize: 24,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													]
																												),
																											),
																										),
																									),
																									Container(
																										margin: const EdgeInsets.only( top: 22),
																										child: Text(
																											"84%",
																											style: TextStyle(
																												color: Color(0xFF3CD7FF),
																												fontSize: 30,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFF27354C),
																							),
																							padding: const EdgeInsets.only( right: 36),
																							margin: const EdgeInsets.only( bottom: 24),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																											color: Color(0xFF3CD7FF),
																											boxShadow: [
																												BoxShadow(
																													color: Color(0x4D3CD7FF),
																													blurRadius: 15,
																													offset: Offset(0, 0),
																												),
																											],
																										),
																										height: 16,
																										width: double.infinity,
																										child: SizedBox(),
																									),
																									IntrinsicHeight(
																										child: SizedBox(
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.end,
																												children: [
																													Container(
																														color: Color(0x66FFFFFF),
																														width: 8,
																														height: 16,
																														child: SizedBox(),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							padding: const EdgeInsets.only( top: 8),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: SizedBox(
																											width: double.infinity,
																											child: Stack(
																												clipBehavior: Clip.none,
																												children: [
																													Padding(
																														padding: const EdgeInsets.only( left: 8, right: 8),
																														child: Row(
																															mainAxisAlignment: MainAxisAlignment.spaceBetween,
																															children: [
																																InkWell(
																																	onTap: () { print('Pressed'); },
																																	child: IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(12),
																																					color: Color(0xFF4AE183),
																																					boxShadow: [
																																						BoxShadow(
																																							color: Color(0x664AE183),
																																							blurRadius: 15,
																																							offset: Offset(0, 0),
																																						),
																																					],
																																				),
																																				padding: const EdgeInsets.only( top: 8, bottom: 8, left: 7, right: 7),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(12),
																																							),
																																							width: 8,
																																							height: 6,
																																							child: ClipRRect(
																																								borderRadius: BorderRadius.circular(12),
																																								child: Image.network(
																																									"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/0436af14-684f-419a-9955-652070cf285a",
																																									fit: BoxFit.fill,
																																								)
																																							)
																																						),
																																					]
																																				),
																																			),
																																		),
																																	),
																																),
																																InkWell(
																																	onTap: () { print('Pressed'); },
																																	child: IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					borderRadius: BorderRadius.circular(12),
																																					color: Color(0xFF4AE183),
																																					boxShadow: [
																																						BoxShadow(
																																							color: Color(0x664AE183),
																																							blurRadius: 15,
																																							offset: Offset(0, 0),
																																						),
																																					],
																																				),
																																				padding: const EdgeInsets.only( top: 8, bottom: 8, left: 7, right: 7),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(12),
																																							),
																																							width: 8,
																																							height: 6,
																																							child: ClipRRect(
																																								borderRadius: BorderRadius.circular(12),
																																								child: Image.network(
																																									"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/a93953ec-3086-4313-ba0e-93ce6c0945b5",
																																									fit: BoxFit.fill,
																																								)
																																							)
																																						),
																																					]
																																				),
																																			),
																																		),
																																	),
																																),
																																InkWell(
																																	onTap: () { print('Pressed'); },
																																	child: IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0xFF3CD7FF),
																																						width: 2,
																																					),
																																					borderRadius: BorderRadius.circular(12),
																																					color: Color(0xFF001C24),
																																				),
																																				padding: const EdgeInsets.all(8),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(12),
																																								color: Color(0xFF3CD7FF),
																																							),
																																							width: 8,
																																							height: 8,
																																							child: SizedBox(),
																																						),
																																					]
																																				),
																																			),
																																		),
																																	),
																																),
																																Container(
																																	decoration: BoxDecoration(
																																		border: Border.all(
																																			color: Color(0x4D44474D),
																																			width: 1,
																																		),
																																		borderRadius: BorderRadius.circular(12),
																																		color: Color(0xFF27354C),
																																	),
																																	width: 24,
																																	height: 24,
																																	child: SizedBox(),
																																),
																															]
																														),
																													),
																													Positioned(
																														bottom: 11,
																														left: 0,
																														right: 0,
																														height: 1,
																														child: Container(
																															color: Color(0x4D44474D),
																															height: 1,
																															width: double.infinity,
																															child: SizedBox(),
																														),
																													),
																												]
																											),
																										),
																									),
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.symmetric(horizontal: 11),
																											width: double.infinity,
																											child: Row(
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 11, bottom: 3),
																																margin: const EdgeInsets.only( right: 42),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Init",
																																			style: TextStyle(
																																				color: Color(0xFFC5C6CD),
																																				fontSize: 10,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 11, bottom: 3),
																																margin: const EdgeInsets.only( right: 39),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Design",
																																			style: TextStyle(
																																				color: Color(0xFFC5C6CD),
																																				fontSize: 10,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 11, bottom: 3),
																																margin: const EdgeInsets.only( right: 39),
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Build",
																																			style: TextStyle(
																																				color: Color(0xFF3CD7FF),
																																				fontSize: 10,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																													Expanded(
																														child: IntrinsicHeight(
																															child: Container(
																																padding: const EdgeInsets.only( top: 11, bottom: 3),
																																width: double.infinity,
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"Launch",
																																			style: TextStyle(
																																				color: Color(0xFF8F9097),
																																				fontSize: 10,
																																				fontWeight: FontWeight.bold,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																													),
																												]
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicWidth(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( bottom: 117),
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( left: 9, right: 9),
																									margin: const EdgeInsets.only( bottom: 16),
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											Text(
																												"Stay on Target",
																												style: TextStyle(
																													color: Color(0xFF3CD7FF),
																													fontSize: 36,
																													fontWeight: FontWeight.bold,
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									padding: const EdgeInsets.only( top: 7, left: 1, right: 1),
																									child: Column(
																										children: [
																											Container(
																												margin: const EdgeInsets.only( bottom: 17),
																												child: Text(
																													"Real-time milestone visualization with",
																													style: TextStyle(
																														color: Color(0xFFC5C6CD),
																														fontSize: 16,
																													),
																												),
																											),
																											Container(
																												margin: const EdgeInsets.only( bottom: 28),
																												child: Text(
																													"Mint-status indicators for peak\nperformance.",
																													style: TextStyle(
																														color: Color(0xFF4AE183),
																														fontSize: 16,
																														fontWeight: FontWeight.bold,
																													),
																												),
																											),
																										]
																									),
																								),
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			decoration: BoxDecoration(
																				borderRadius: BorderRadius.circular(8),
																				color: Color(0xFF4AE183),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x4D3CD7FF),
																						blurRadius: 20,
																						offset: Offset(0, 0),
																					),
																				],
																			),
																			padding: const EdgeInsets.symmetric(vertical: 16),
																			margin: const EdgeInsets.only( bottom: 29, left: 32, right: 32),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.center,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( bottom: 1),
																								margin: const EdgeInsets.only( right: 7),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"Start",
																											style: TextStyle(
																												color: Color(0xFF003642),
																												fontSize: 18,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(8),
																						),
																						width: 6,
																						height: 10,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(8),
																							child: Image.network(
																								"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/74f69d45-3d08-45df-96ee-fa06a9fa31f3",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			color: Color(0xCC041329),
																			padding: const EdgeInsets.only( top: 16, bottom: 40, left: 32, right: 32),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Row(
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																											color: Color(0xFF27354C),
																										),
																										margin: const EdgeInsets.only( right: 16),
																										width: 8,
																										height: 8,
																										child: SizedBox(),
																									),
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																											color: Color(0xFF27354C),
																										),
																										margin: const EdgeInsets.only( right: 16),
																										width: 8,
																										height: 8,
																										child: SizedBox(),
																									),
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(12),
																											color: Color(0xFF3CD7FF),
																											boxShadow: [
																												BoxShadow(
																													color: Color(0x803CD7FF),
																													blurRadius: 10,
																													offset: Offset(0, 0),
																												),
																											],
																										),
																										width: 12,
																										height: 12,
																										child: SizedBox(),
																									),
																								]
																							),
																						),
																					),
																					SizedBox(
																						width: 16,
																						height: 16,
																						child: SizedBox(),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}