import 'package:collection/collection.dart';
import 'package:nucleus_one_dart_sdk/nucleus_one_dart_sdk.dart' as n1;

typedef _GetQueryResultByCursorFn = Future<n1.QueryResult> Function(
    String? cursor);

class NucleusOneSdkService {
  NucleusOneSdkService(this.n1App);

  n1.NucleusOneApp n1App;

  Future<List<n1.UserOrganization>> getUserOrganizations() async {
    return (await n1App.users().getOrganizations()).items;
  }

  Future<List<n1.OrganizationProject>> getOrganizationProjects({
    required String organizationId,
  }) async {
    final _GetQueryResultByCursorFn getQrFn = ((cursor) {
      return n1App
          .organization(organizationId)
          .getProjects(organizationId: organizationId, cursor: cursor);
    });
    return _getAllByPaging(getQrFn);
  }

  Future<n1.OrganizationProject?> getOrganizationProject({
    required String organizationId,
    required String projectId,
  }) async {
    return (await getOrganizationProjects(organizationId: organizationId))
        .firstWhereOrNull((p) => p.id == projectId);
  }

  /// If [parentId] is null, then returns folders at root,
  Future<List<n1.DocumentFolder>> getDocumentFolders({
    required String organizationId,
    required String projectId,
    String? parentId,
  }) async {
    final _GetQueryResultByCursorFn getQrFn = ((cursor) {
      return n1App
          .organization(organizationId)
          .project(projectId)
          .getDocumentFolders(parentId: parentId, cursor: cursor);
    });
    return _getAllByPaging(getQrFn);
  }

  Future<List<T>> _getAllByPaging<T>(_GetQueryResultByCursorFn getQrFn) async {
    final items = <T>[];
    String? cursor;
    n1.QueryResult queryResult;
    do {
      queryResult = await getQrFn(cursor);
      cursor = queryResult.cursor;

      final pageItems = queryResult.results.items as List<T>;
      items.addAll(pageItems);
    } while (queryResult.results.items.isNotEmpty);

    return items;
  }
}
