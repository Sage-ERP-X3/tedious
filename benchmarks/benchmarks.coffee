{Request, TYPES} = require "../src/tedious"
async = require "async"

module.exports =
  "large number of rows":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([id] int IDENTITY(1,1), [name] nvarchar(100), [description] nvarchar(max))", (err) ->
        return cb(err) if err

        async.timesSeries 10000, ((n, next) ->
          request = new Request "INSERT INTO #benchmark ([name], [description]) VALUES (@name, @description)", next
          request.addParameter("name", TYPES.NVarChar, "Row " + n)
          request.addParameter("description", TYPES.NVarChar, "Example Test Description for Row " + n)
          connection.execSql(request)
        ), cb

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)

  "nvarchar (small)":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([value] nvarchar(max))", (err) ->
        return cb(err) if err

        request = new Request "INSERT INTO #benchmark ([value]) VALUES (@value)", cb
        request.addParameter("value", TYPES.NVarChar, "asdf")
        connection.execSql(request)

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)

  "nvarchar (large)":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([value] nvarchar(max))", (err) ->
        return cb(err) if err

        request = new Request "INSERT INTO #benchmark ([value]) VALUES (@value)", cb
        request.addParameter("value", TYPES.NVarChar, new Array(5 * 1024 * 1024).join("x"))
        connection.execSql(request)

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)

  "varbinary (small)":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([value] varbinary(max))", (err) ->
        return cb(err) if err

        request = new Request "INSERT INTO #benchmark ([value]) VALUES (@value)", cb
        request.addParameter("value", TYPES.VarBinary, new Buffer("asdf"))
        connection.execSql(request)

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)

  "varbinary (4)":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([value] varbinary(4))", (err) ->
        return cb(err) if err

        request = new Request "INSERT INTO #benchmark ([value]) VALUES (@value)", cb
        request.addParameter("value", TYPES.VarBinary, new Buffer("asdf"))
        connection.execSql(request)

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)


  "varbinary (large)":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([value] varbinary(max))", (err) ->
        return cb(err) if err

        request = new Request "INSERT INTO #benchmark ([value]) VALUES (@value)", cb
        buf = new Buffer(5 * 1024 * 1024)
        buf.fill("x")
        request.addParameter("value", TYPES.VarBinary, buf)
        connection.execSql(request)

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)

  "varbinary (huge)":
    setup: (connection, cb) ->
      request = new Request "CREATE TABLE #benchmark ([value] varbinary(max))", (err) ->
        return cb(err) if err

        request = new Request "INSERT INTO #benchmark ([value]) VALUES (@value)", cb
        buf = new Buffer(50 * 1024 * 1024)
        buf.fill("x")
        request.addParameter("value", TYPES.VarBinary, buf)
        connection.execSql(request)

      connection.execSqlBatch(request)

    exec: (connection, cb) ->
      request = new Request "SELECT * FROM #benchmark", cb
      connection.execSql(request)

    teardown: (connection, cb) ->
      request = new Request "DROP TABLE #benchmark", cb
      connection.execSqlBatch(request)
