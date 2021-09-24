import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/http/customer.agent.dart';

class AgentsBloc {
  final AgentsApiProvider _provider = AgentsApiProvider();
  final BehaviorSubject<AgentResponse> _subSubject =
      BehaviorSubject<AgentResponse>();

  getAgents() async {
    AgentResponse response = await _provider.getAgents();
    _subSubject.sink.add(response);
  }

  dispose() {
    _subSubject.close();
  }

  BehaviorSubject<AgentResponse> get subject => _subSubject;
}

final agentBloc = AgentsBloc();
