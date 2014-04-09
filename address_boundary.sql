\set tab address_boundary

DROP TABLE IF EXISTS :"tab";

CREATE TABLE :"tab" (
    code varchar(5) PRIMARY KEY CHECK (length(code) = 5),
    pref varchar(10) NOT NULL,
    name varchar(60) NOT NULL,
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

COMMENT ON TABLE :"tab" IS '「国土数値情報（行政区域データ）　国土交通省」 平成２５年度データ';
