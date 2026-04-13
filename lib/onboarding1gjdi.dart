import 'package:flutter/material.dart';
class Onboarding1 extends StatefulWidget {
	const Onboarding1({super.key});
	@override
	Onboarding1State createState() => Onboarding1State();
}
class Onboarding1State extends State<Onboarding1> {
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
											padding: const EdgeInsets.only( bottom: 72),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: SizedBox(
															width: double.infinity,
															child: Stack(
																clipBehavior: Clip.none,
																children: [
																	Column(
																		crossAxisAlignment: CrossAxisAlignment.start,
																		children: [
																			IntrinsicHeight(
																				child: Container(
																					color: Color(0x00000000),
																					padding: const EdgeInsets.only( top: 22),
																					width: double.infinity,
																					child: Column(
																						crossAxisAlignment: CrossAxisAlignment.start,
																						children: [
																							IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 11, left: 26, right: 26),
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
																													"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/e4090108-7969-4767-94e6-b0e5791532fd",
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
																									padding: const EdgeInsets.only( top: 8, bottom: 8, left: 16, right: 16),
																									margin: const EdgeInsets.only( bottom: 27),
																									width: double.infinity,
																									child: Row(
																										mainAxisAlignment: MainAxisAlignment.spaceBetween,
																										children: [
																											SizedBox(
																												width: 16,
																												height: 16,
																												child: Image.network(
																													"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/15cdca61-a611-4e20-93e2-be6ee04964b8",
																													fit: BoxFit.fill,
																												)
																											),
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.symmetric(vertical: 7),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"PROJECTPALS",
																																	style: TextStyle(
																																		color: Color(0xFFD6E3FF),
																																		fontSize: 18,
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
																														padding: const EdgeInsets.symmetric(vertical: 4),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"Skip",
																																	style: TextStyle(
																																		color: Color(0xFF3CD7FF),
																																		fontSize: 14,
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
																							IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(12),
																										color: Color(0x0D3CD7FF),
																									),
																									padding: const EdgeInsets.only( left: 32, right: 32),
																									margin: const EdgeInsets.only( bottom: 29, left: 35, right: 35),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0x333CD7FF),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(12),
																													),
																													padding: const EdgeInsets.all(1),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(12),
																																),
																																height: 254,
																																width: double.infinity,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(12),
																																	child: Image.network(
																																		"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/c55835d6-7c72-4196-bb87-b8049f7cee75",
																																		fit: BoxFit.fill,
																																	)
																																)
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
																									margin: const EdgeInsets.only( bottom: 77, left: 44, right: 44),
																									width: double.infinity,
																									child: Column(
																										crossAxisAlignment: CrossAxisAlignment.start,
																										children: [
																											IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( bottom: 1),
																													margin: const EdgeInsets.only( bottom: 24),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															SizedBox(
																																width: double.infinity,
																																child: Text(
																																	"Find Your Perfect\nMatch",
																																	style: TextStyle(
																																		color: Color(0xFFD6E3FF),
																																		fontSize: 36,
																																		fontWeight: FontWeight.bold,
																																	),
																																	textAlign: TextAlign.center,
																																),
																															),
																														]
																													),
																												),
																											),
																											IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( top: 6, bottom: 6, left: 16, right: 16),
																													width: double.infinity,
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															SizedBox(
																																width: double.infinity,
																																child: Text(
																																	"Our neural engine analyzes skills and\npersonality traits to find your perfect\nco-builders.",
																																	style: TextStyle(
																																		color: Color(0xFFC5C6CD),
																																		fontSize: 16,
																																	),
																																	textAlign: TextAlign.center,
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
																							IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										borderRadius: BorderRadius.circular(8),
																										color: Color(0xFF3CD7FF),
																										boxShadow: [
																											BoxShadow(
																												color: Color(0x4D3CD7FF),
																												blurRadius: 20,
																												offset: Offset(0, 0),
																											),
																										],
																									),
																									padding: const EdgeInsets.symmetric(vertical: 23),
																									margin: const EdgeInsets.only( bottom: 73, left: 35, right: 35),
																									width: double.infinity,
																									child: Row(
																										mainAxisAlignment: MainAxisAlignment.center,
																										children: [
																											IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														padding: const EdgeInsets.only( bottom: 1),
																														margin: const EdgeInsets.only( right: 9),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																Text(
																																	"Next",
                                                                  
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
																														"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/a6b1d83f-b9fd-4944-a7c1-12f92d9f7240",
																														fit: BoxFit.fill,
																													)
																												)
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
																	Positioned(
																		bottom: 0,
																		left: 0,
																		right: 0,
																		child: IntrinsicHeight(
																			child: Container(
																				color: Color(0xCC041329),
																				padding: const EdgeInsets.only( top: 18, left: 32),
																				transform: Matrix4.translationValues(0, 36, 0),
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						IntrinsicWidth(
																							child: IntrinsicHeight(
																								child: Container(
																									margin: const EdgeInsets.only( bottom: 42),
																									child: Row(
																										children: [
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
																												margin: const EdgeInsets.only( right: 16),
																												width: 12,
																												height: 12,
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
																													color: Color(0xFF27354C),
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
																					]
																				),
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