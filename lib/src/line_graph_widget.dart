import 'package:flutter/material.dart';
import 'package:line_graph/src/line_graph_painter.dart';

class LineGraphWidget extends StatefulWidget {
  LineGraphWidget({
    this.data = const [],
  }) : super();
  final List<double> data;

  @override
  _LineGraphWidgetState createState() => _LineGraphWidgetState();
}

class _LineGraphWidgetState extends State<LineGraphWidget> {
  GlobalKey _key = GlobalKey();
  bool _isLoading = false;

  /// 선택된 그래프 포인트
  int _selectedIndex = 0;

  /// 사용가능한 그래프 영역 높이
  double _graphHeight = 0.0;

  /// 각 y축이 가지는 높이
  double _yBoxHeight = 0;

  /// y축 default 높이값
  double _yAxisHeight = 100.0;

  /// y축 증가값
  double _yAxisSpacing = 15.0;

  double _maxY = 0.0;
  double _minY = 0.0;

  Size? _getGraphSize() {
    return _key.currentContext?.size;
  }

  void _setGraph() {
      _maxY = widget.data.fold(0, (previousValue, element) => previousValue > element ? previousValue : element);
      _minY = widget.data.fold(0, (previousValue, element) => previousValue < element ? previousValue : element);
      _maxY += 0.5;
      _minY += 0.5;
      _graphHeight = _getGraphSize()!.height;
      /// (_graphHeight ~/ _yAxisHeight) : 그래프 영역을 일정 크기로 나눠주어 총 몇개의 영역으로 나뉘는지 계산
      /// (_graphHeight - 50.0) : 그래프 영역에서 x축 영역을 제거
      /// x축의 높이를 제거 한 영역의 크기를 들어갈 수 있는 영역 개수로 나눠주어 y축 한 개의 크기를 계산
      _yBoxHeight = (_graphHeight - 50.0) / (_graphHeight ~/ _yAxisHeight);
      _yAxisSpacing = (_maxY - _minY) / (_graphHeight ~/ _yAxisHeight - 1);
  }



  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if ((_getGraphSize() != null && _isLoading == false) || _getGraphSize()!.height != _graphHeight) {
        _setGraph();
        setState(() {
          _isLoading = true;
        });
      }
    });

    return Flexible(
      fit: FlexFit.tight,
      key: _key,
      child: _graphHeight > 0
          ? Stack(
        children: [
          SingleChildScrollView(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: LineGraphPainter(height: _graphHeight,
                    data: widget.data,
                    minY: 10,
                    yAxisSpacing: 3,
                    yBoxHeight: _yBoxHeight),
                isComplex: true,
                willChange: false,

                /// 54.0 = 첫 지점 여백 30.0 + 우측 마지막 여백 24.0
                size: Size(widget.data.length * 40.0 + 54.0, _graphHeight),
              ),
            ),
            scrollDirection: Axis.horizontal,
            // controller: _chartController,
          ),
          ListView.builder(
            scrollDirection: Axis.horizontal,
            // controller: _scrollController,
            itemBuilder: (context, index) {
              return Row(
                children: [

                  /// y축
                  Visibility(
                    visible: index == 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Container(
                        width: 50.0,
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.grey, width: 2.0)),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < _graphHeight ~/ _yAxisHeight; i++)
                              Container(
                                height: _yBoxHeight,
                                alignment: Alignment.center,
                                child: Text("${(_yAxisSpacing * (i)).toInt()}"),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// 첫 지점 간격 조절
                  if (index == 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Container(
                        width: 30.0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2.0),
                          ),
                        ),
                      ),
                    ),

                  /// 원 그리기
                  GestureDetector(
                    onLongPressStart: (_) {},
                    onLongPress: () {},
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: _graphHeight - 50.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 2.0),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // DottedLine(
                              //   dashColor: hexToColor("#F0F0F0"),
                              //   lineThickness: 1,
                              //   direction: Axis.vertical,
                              // ),
                              Positioned(
                                bottom: (widget.data[index] - (10 - (_yAxisSpacing / 2))) * (_yBoxHeight / _yAxisSpacing) - 10.0,
                                child: _selectedIndex == index
                                    ? Container(
                                  height: 16.0,
                                  width: 16.0,
                                  decoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(2.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                                    : Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                                ),
                              )
                            ],
                          ),
                        ),

                        /// x축 정보 입력 창
                        Container(
                          padding: const EdgeInsets.only(top: 4.0),
                          height: 50.0,
                          alignment: Alignment.topCenter,
                          child: Text(
                            "x축",
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (index == widget.data.length - 1) SizedBox(width: 24.0),
                ],
              );
            },
            itemCount: widget.data.length,
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
