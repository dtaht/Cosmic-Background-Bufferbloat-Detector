// Should I just emulate the ntp timestamp entirely?



typedef struct Ntp_Timestamp {
    unsigned int      x;
    unsigned int      y;
} Ntp_Timestamp;

PG_FUNCTION_INFO_V1(ntp_timestamp_in);

Datum
ntp_timestamp_in(PG_FUNCTION_ARGS)
{
    char       *str = PG_GETARG_CSTRING(0);
    unsigned int      x,
                y;
    Ntp_Timestamp    *result;

    if (sscanf(str, " ( %lf , %lf )", &x, &y) != 2)
        ereport(ERROR,
                (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                 errmsg("invalid input syntax for ntp_timestamp: \"%s\"",
                        str)));

    result = (Ntp_Timestamp *) palloc(sizeof(Ntp_Timestamp));
    result->x = x;
    result->y = y;
    PG_RETURN_POINTER(result);
}

PG_FUNCTION_INFO_V1(ntp_timestamp_out);

Datum
ntp_timestamp_out(PG_FUNCTION_ARGS)
{
    Ntp_Timestamp    *ntp_timestamp = (Ntp_Timestamp *) PG_GETARG_POINTER(0);
    char       *result;

    result = (char *) palloc(100);
    snprintf(result, 100, "(%g,%g)", ntp_timestamp->x, ntp_timestamp->y);
    PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(ntp_timestamp_recv);

Datum
ntp_timestamp_recv(PG_FUNCTION_ARGS)
{
    StringInfo  buf = (StringInfo) PG_GETARG_POINTER(0);
    Ntp_Timestamp    *result;

    result = (Ntp_Timestamp *) palloc(sizeof(Ntp_Timestamp));
    result->x = pq_getmsgfloat8(buf);
    result->y = pq_getmsgfloat8(buf);
    PG_RETURN_POINTER(result);
}

PG_FUNCTION_INFO_V1(ntp_timestamp_send);

Datum
ntp_timestamp_send(PG_FUNCTION_ARGS)
{
    Ntp_Timestamp    *ntp_timestamp = (Ntp_Timestamp *) PG_GETARG_POINTER(0);
    StringInfoData buf;

    pq_begintypsend(&buf);
    pq_sendfloat8(&buf, ntp_timestamp->x);
    pq_sendfloat8(&buf, ntp_timestamp->y);
    PG_RETURN_BYTEA_P(pq_endtypsend(&buf));
}

