import 'package:pull_to_refresh/pull_to_refresh.dart';

class StatusEvent {
  String labelId;
  RefreshStatus status;
  int cid;

  StatusEvent(this.labelId, this.status, {this.cid});
}
