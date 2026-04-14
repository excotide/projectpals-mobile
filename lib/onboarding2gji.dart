import 'package:flutter/material.dart';
class Onboarding2 extends StatefulWidget {
	const Onboarding2({super.key});
	@override
	Onboarding2State createState() => Onboarding2State();
}
class Onboarding2State extends State<Onboarding2> {
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
											child: Column(
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
																							"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/2663f4de-2fed-4459-80ad-fe17a3a29371",
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
																			padding: const EdgeInsets.only( top: 11, bottom: 11, left: 16, right: 16),
																			margin: const EdgeInsets.only( bottom: 12, left: 1, right: 1),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					SizedBox(
																						width: 16,
																						height: 16,
																						child: Image.network(
																							"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/d1e402c4-c951-49e2-a315-c46eb95509c7",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( bottom: 1),
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
																								padding: const EdgeInsets.symmetric(vertical: 5),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"Skip",
																											style: TextStyle(
																												color: Color(0xFF3CD7FF),
																												fontSize: 16,
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
																			padding: const EdgeInsets.only( top: 27, right: 19),
																			margin: const EdgeInsets.only( bottom: 19, left: 36, right: 15),
																			width: double.infinity,
																			child: Column(
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
																																			decoration: BoxDecoration(
																																				borderRadius: BorderRadius.circular(12),
																																				color: Color(0x1A3CD7FF),
																																			),
																																			padding: const EdgeInsets.only( top: 39, bottom: 39, left: 40, right: 40),
																																			width: double.infinity,
																																			child: Column(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								borderRadius: BorderRadius.circular(12),
																																								color: Color(0x0D4AE183),
																																							),
																																							padding: const EdgeInsets.only( top: 18, bottom: 18, left: 36, right: 36),
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
																																												color: Color(0x9927354C),
																																												boxShadow: [
																																													BoxShadow(
																																														color: Color(0x263CD7FF),
																																														blurRadius: 20,
																																														offset: Offset(0, 0),
																																													),
																																												],
																																											),
																																											padding: const EdgeInsets.symmetric(vertical: 32),
																																											width: double.infinity,
																																											child: Column(
																																												children: [
																																													Container(
																																														decoration: BoxDecoration(
																																															borderRadius: BorderRadius.circular(12),
																																														),
																																														width: 48,
																																														height: 76,
																																														child: ClipRRect(
																																															borderRadius: BorderRadius.circular(12),
																																															child: Image.network(
																																																"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/b9d270a9-5f50-44e0-88c7-e24319cc9222",
																																																fit: BoxFit.fill,
																																															)
																																														)
																																													),
																																													IntrinsicWidth(
																																														child: IntrinsicHeight(
																																															child: Container(
																																																padding: const EdgeInsets.only( bottom: 8),
																																																margin: const EdgeInsets.only( bottom: 1),
																																																child: Column(
																																																	crossAxisAlignment: CrossAxisAlignment.start,
																																																	children: [
																																																		SizedBox(
																																																			width: 99,
																																																			height: 15,
																																																			child: Image.network(
																																																				"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/7bf814d1-96af-4a55-9c43-920785e7b302",
																																																				fit: BoxFit.fill,
																																																			)
																																																		),
																																																	]
																																																),
																																															),
																																														),
																																													),
																																													IntrinsicWidth(
																																														child: IntrinsicHeight(
																																															child: Container(
																																																padding: const EdgeInsets.symmetric(vertical: 3),
																																																child: Column(
																																																	crossAxisAlignment: CrossAxisAlignment.start,
																																																	children: [
																																																		Text(
																																																			"Trust Index: 98%",
																																																			style: TextStyle(
																																																				color: Color(0xFFC5C6CD),
																																																				fontSize: 10,
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
																																]
																															),
																															Positioned(
																																bottom: 26,
																																left: 0,
																																child: InkWell(
																																	onTap: () { debugPrint('Pressed'); },
																																	child: IntrinsicWidth(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				decoration: BoxDecoration(
																																					border: Border.all(
																																						color: Color(0x4D4AE183),
																																						width: 1,
																																					),
																																					borderRadius: BorderRadius.circular(12),
																																					color: Color(0x9927354C),
																																				),
																																				padding: const EdgeInsets.only( top: 12, bottom: 12, left: 13, right: 13),
																																				transform: Matrix4.translationValues(-25, 0, 0),
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Row(
																																									children: [
																																										Container(
																																											decoration: BoxDecoration(
																																												borderRadius: BorderRadius.circular(12),
																																											),
																																											margin: const EdgeInsets.only( right: 8),
																																											width: 12,
																																											height: 12,
																																											child: ClipRRect(
																																												borderRadius: BorderRadius.circular(12),
																																												child: Image.network(
																																													"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/68e9ce10-cfbe-46e0-8bbe-bfba22a9651d",
																																													fit: BoxFit.fill,
																																												)
																																											)
																																										),
																																										Text(
																																											"High Quality",
																																											style: TextStyle(
																																												color: Color(0xFFD6E3FF),
																																												fontSize: 10,
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
																																),
																															),
																														]
																													),
																												),
																											),
																										]
																									),
																									Positioned(
																										top: 0,
																										right: 0,
																										child: InkWell(
																											onTap: () { debugPrint('Pressed'); },
																											child: IntrinsicWidth(
																												child: IntrinsicHeight(
																													child: Container(
																														decoration: BoxDecoration(
																															border: Border.all(
																																color: Color(0x4D3CD7FF),
																																width: 1,
																															),
																															borderRadius: BorderRadius.circular(12),
																															color: Color(0x9927354C),
																														),
																														padding: const EdgeInsets.only( top: 13, bottom: 13, left: 14, right: 14),
																														transform: Matrix4.translationValues(19, -27, 0),
																														child: Column(
																															crossAxisAlignment: CrossAxisAlignment.start,
																															children: [
																																IntrinsicWidth(
																																	child: IntrinsicHeight(
																																		child: Container(
																																			padding: const EdgeInsets.symmetric(vertical: 6),
																																			child: Row(
																																				crossAxisAlignment: CrossAxisAlignment.start,
																																				children: [
																																					Container(
																																						decoration: BoxDecoration(
																																							borderRadius: BorderRadius.circular(12),
																																						),
																																						margin: const EdgeInsets.only( right: 7),
																																						width: 14,
																																						height: 14,
																																						child: ClipRRect(
																																							borderRadius: BorderRadius.circular(12),
																																							child: Image.network(
																																								"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/aad5b4fe-bccd-47e7-be88-54f68848cd45",
																																								fit: BoxFit.fill,
																																							)
																																						)
																																					),
																																					Text(
																																						"Commitment",
																																						style: TextStyle(
																																							color: Color(0xFFD6E3FF),
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
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					SizedBox(
																						width: 181,
																						child: Text(
																							"Build Your\nReputation",
																							style: TextStyle(
																								color: Color(0xFF3CD7FF),
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
																			padding: const EdgeInsets.only( top: 5, bottom: 5, left: 8, right: 8),
																			margin: const EdgeInsets.only( bottom: 74, left: 30, right: 30),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					SizedBox(
																						width: double.infinity,
																						child: Text(
																							"Reputation-based ecosystem ensuring\ncommitment and high-quality collaborative\noutputs.",
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
																			margin: const EdgeInsets.only( bottom: 35, left: 35, right: 35),
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
																								"https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/76e171e6-f97f-428f-8de6-8d891c5af275",
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
																			padding: const EdgeInsets.only( top: 18, bottom: 42, left: 32),
																			margin: const EdgeInsets.only( bottom: 39),
																			width: double.infinity,
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
																						width: 8,
																						height: 8,
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