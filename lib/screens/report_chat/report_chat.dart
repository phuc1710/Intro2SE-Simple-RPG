import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/report.dart';
import 'package:simple_rpg/models/user.dart';

class ReportChat extends StatefulWidget {
  const ReportChat({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _ReportChatState createState() => _ReportChatState();
}

class _ReportChatState extends State<ReportChat> {
  bool isSearch = false;
  bool isInit = true;
  var reportGeneral;
  var totalReports;
  var page = 0;
  var lastPage;
  var showReports;
  final searchController = TextEditingController();
  var isInDetail = false;
  var allReportRef;
  static const reportPerPage = 5;
  static const topElePadding = 10.0;
  @override
  void initState() {
    super.initState();
    allReportRef = Report.getAllReportRef();
    allReportRef?.onChildAdded.listen(_onReportAdded);
    allReportRef?.onChildRemoved.listen(_onReportRemoved);
    reportGeneral = getReportGeneral(Report.getListReport());
  }

  _onReportAdded(event) {
    if (this.mounted) {
      setState(() {
        var newReport = Report.fromDB(event.snapshot.value);
        try {
          totalReports.add(newReport);
          showReports = totalReports;
          reportGeneral = getReportGeneral(totalReports);
        } catch (e) {}
      });
    }
  }

  _onReportRemoved(event) {
    if (this.mounted) {
      setState(() {
        var removedReport = Report.fromDB(event.snapshot.value);
        removeAndUpdate(removedReport);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return reportGeneral;
  }

  Column getReportGeneral(dynamic list) {
    return Column(
      children: [
        Expanded(
          child: searchBar(),
        ),
        Expanded(
          flex: 6,
          child: isInit ? getAsync(list) : getSync(list),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      page--;
                      if (page >= 0)
                        reportGeneral = getReportGeneral(getPageUsers());
                      else
                        page = 0;
                    });
                  },
                  child: Text('Trang trước'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      page++;
                      if (page <= getLastPage())
                        reportGeneral = getReportGeneral(getPageUsers());
                      else
                        page = getLastPage();
                    });
                  },
                  child: Text('Trang tiếp theo'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding searchBar({backButton}) {
    return Padding(
      padding: EdgeInsets.all(topElePadding),
      child: Row(children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Card(
                child: TextField(
                  enabled: !isSearch,
                  controller: searchController,
                ),
              ),
            ),
            flex: 7),
        Expanded(
          child: TextButton(
            child: Icon(
              isSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            style: ButtonStyle(
              backgroundColor: isSearch
                  ? MaterialStateProperty.all(Colors.red[400])
                  : MaterialStateProperty.all(Colors.blue),
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              setState(() {
                if (!isSearch) {
                  if (searchController.text != '') {
                    isSearch = !isSearch;
                    final searchKey = searchController.text.toLowerCase();
                    var matchReports = [];
                    var fromCon, chatCon;
                    for (var rp in totalReports) {
                      fromCon = rp.fromUsername
                          .toLowerCase()
                          .contains(searchKey.toLowerCase());
                      chatCon = rp.chat
                          .toLowerCase()
                          .contains(searchKey.toLowerCase());
                      if (fromCon || chatCon) {
                        matchReports.add(rp);
                      }
                    }
                    showReports = matchReports;
                    page = 0;
                    reportGeneral = getReportGeneral(getPageUsers());
                  }
                } else {
                  searchController.clear();
                  isSearch = !isSearch;
                  page = 0;
                  showReports = totalReports;
                  reportGeneral = getReportGeneral(getPageUsers());
                }
              });
            },
          ),
          flex: 1,
        ),
      ]),
    );
  }

  FutureBuilder<List<dynamic>> getAsync(Future<List<dynamic>> list) {
    return FutureBuilder<List>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          totalReports = snapshot.data;
          showReports = totalReports;
          isInit = false;
          return getSync(getPageUsers());
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }

  removeAndUpdate(listReport) {
    removeReport(listReport);
    reportGeneral = getReportGeneral(totalReports);
  }

  removeReport(listReport) {
    for (var i = 0; i < totalReports.length; ++i) {
      if (listReport.compare(totalReports[i])) {
        totalReports.removeAt(i);
        break;
      }
    }
  }

  Widget getSync(List<dynamic> list) {
    return list.length == 0
        ? Center(
            child: Text('KHÔNG CÓ BÁO CÁO NÀO'),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              Report listReport = list[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    Icons.feedback,
                    color: Colors.amber[700],
                    size: 40.0,
                  ),
                  title: Text(
                    listReport.toUsername,
                    style: TextStyle(color: Colors.indigo),
                  ),
                  subtitle: Text(
                    listReport.chat,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 5)),
                          minimumSize: MaterialStateProperty.all(Size(50, 50)),
                          overlayColor: MaterialStateProperty.all(
                              Colors.red.withOpacity(0.1)),
                        ),
                        child: Text(
                          'CẤM',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          setState(() {
                            User.banByUsername(listReport.toUsername);
                            listReport.remove();
                          });
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 5)),
                          minimumSize: MaterialStateProperty.all(Size(50, 50)),
                          overlayColor: MaterialStateProperty.all(
                              Colors.grey.withOpacity(0.1)),
                        ),
                        child: Text(
                          'XÓA',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          setState(() {
                            listReport.remove();
                          });
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  List getPageUsers() {
    if (showReports.length == 0) return showReports;
    if (page == getLastPage()) return showReports.sublist(page * reportPerPage);
    return showReports.sublist(
        page * reportPerPage, (page + 1) * reportPerPage);
  }

  int getLastPage() {
    return (showReports.length / reportPerPage).ceil() - 1;
  }
}
