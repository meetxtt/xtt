--
-- PostgreSQL database dump
--

\restrict e4Taw1PLg7vDAz1pevDZibQBbU8hNuULVBY44Yq5OMEZ3glXJXHez1tOjIVbaOf

-- Dumped from database version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: xtt_pro
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO xtt_pro;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_codes; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.access_codes (
    id integer NOT NULL,
    code character varying(100) NOT NULL,
    type character varying(50) DEFAULT 'temporary'::character varying,
    max_connections integer DEFAULT 1,
    allowed_ips jsonb DEFAULT '[]'::jsonb,
    expires timestamp without time zone,
    enabled boolean DEFAULT true,
    owner character varying(150),
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    max_ips integer DEFAULT 0
);


ALTER TABLE public.access_codes OWNER TO xtt_pro;

--
-- Name: access_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.access_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_codes_id_seq OWNER TO xtt_pro;

--
-- Name: access_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.access_codes_id_seq OWNED BY public.access_codes.id;


--
-- Name: backup_lines; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.backup_lines (
    id integer,
    member_id integer,
    username character varying(255),
    password character varying(255),
    last_ip character varying(45),
    exp_date timestamp without time zone,
    admin_enabled boolean,
    enabled boolean,
    admin_notes text,
    reseller_notes text,
    bouquet jsonb,
    allowed_outputs jsonb,
    max_connections integer,
    is_restreamer boolean,
    is_trial boolean,
    is_mag boolean,
    is_e2 boolean,
    is_stalker boolean,
    is_isplock boolean,
    allowed_ips jsonb,
    allowed_ua jsonb,
    created_at timestamp without time zone,
    pair_id integer,
    force_server_id integer,
    as_number character varying(50),
    isp_desc text,
    forced_country character varying(2),
    bypass_ua boolean,
    play_token character varying(255),
    last_expiration_video timestamp without time zone,
    package_id integer,
    access_token character varying(255),
    contact character varying(255),
    last_activity timestamp without time zone,
    last_activity_array jsonb,
    updated_at timestamp without time zone
);


ALTER TABLE public.backup_lines OWNER TO xtt_pro;

--
-- Name: backup_servers; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.backup_servers (
    id integer,
    server_name character varying(255),
    domain_name character varying(255),
    server_ip character varying(39),
    vpn_ip character varying(39),
    ssh_password character varying(255),
    http_broadcast_port integer,
    https_broadcast_port integer,
    https_ports jsonb,
    rtmp_port integer,
    igmp_enabled boolean,
    enable_https boolean,
    network_interface character varying(50),
    latency numeric(8,2),
    status boolean,
    total_clients integer,
    active_clients integer,
    cpu numeric(5,2),
    gpu character varying(255),
    gpu_usage numeric(5,2),
    uptime integer,
    load_average character varying(50),
    bytes_sent bigint,
    bytes_received bigint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.backup_servers OWNER TO xtt_pro;

--
-- Name: backup_users; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.backup_users (
    id integer,
    username character varying(255),
    password character varying(255),
    email character varying(255),
    member_group_id integer,
    last_login timestamp without time zone,
    last_ip character varying(39),
    ip character varying(39),
    enabled boolean,
    theme character varying(50),
    timezone character varying(50),
    api_key character varying(255),
    credits numeric(10,2),
    notes text,
    reseller_notes text,
    owner_id integer,
    override_packages jsonb,
    hulu_settings jsonb,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.backup_users OWNER TO xtt_pro;

--
-- Name: billing_transactions; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.billing_transactions (
    id integer NOT NULL,
    customer_id integer,
    reseller_id integer,
    package_id integer,
    transaction_type character varying(50) NOT NULL,
    amount numeric(10,2) NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying,
    description text,
    payment_method character varying(50),
    payment_reference character varying(255),
    payment_status character varying(50) DEFAULT 'pending'::character varying,
    billing_period_start date,
    billing_period_end date,
    external_transaction_id character varying(255),
    gateway_response jsonb DEFAULT '{}'::jsonb,
    processed_by integer,
    processed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.billing_transactions OWNER TO xtt_pro;

--
-- Name: billing_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.billing_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billing_transactions_id_seq OWNER TO xtt_pro;

--
-- Name: billing_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.billing_transactions_id_seq OWNED BY public.billing_transactions.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.providers (
    id integer NOT NULL,
    provider_name character varying(255) NOT NULL,
    description text,
    provider_channels jsonb,
    is_adult boolean DEFAULT false,
    provider_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    provider_accounts jsonb DEFAULT '[]'::jsonb,
    provider_scripts jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.providers OWNER TO xtt_pro;

--
-- Name: bouquets_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.bouquets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bouquets_id_seq OWNER TO xtt_pro;

--
-- Name: bouquets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.bouquets_id_seq OWNED BY public.providers.id;


--
-- Name: connection_sessions; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.connection_sessions (
    id integer NOT NULL,
    customer_id integer,
    access_code_id integer,
    content_item_id integer,
    server_id integer,
    ip_address inet NOT NULL,
    user_agent text,
    country_code character varying(2),
    isp_name character varying(150),
    stream_format character varying(50) DEFAULT 'ts'::character varying,
    stream_quality character varying(20) DEFAULT 'source'::character varying,
    bitrate_kbps integer,
    started_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_activity_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ended_at timestamp without time zone,
    duration_seconds integer,
    bytes_uploaded bigint DEFAULT 0,
    bytes_downloaded bigint DEFAULT 0,
    session_status character varying(20) DEFAULT 'active'::character varying,
    disconnect_reason character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.connection_sessions OWNER TO xtt_pro;

--
-- Name: connection_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.connection_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.connection_sessions_id_seq OWNER TO xtt_pro;

--
-- Name: connection_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.connection_sessions_id_seq OWNED BY public.connection_sessions.id;


--
-- Name: streams_categories; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.streams_categories (
    id integer NOT NULL,
    category_name character varying(150) NOT NULL,
    slug character varying(150) NOT NULL,
    description text,
    category_type character varying(50) NOT NULL,
    parent_id integer,
    category_order integer DEFAULT 0,
    icon_url character varying(500),
    is_adult boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.streams_categories OWNER TO xtt_pro;

--
-- Name: content_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.content_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_categories_id_seq OWNER TO xtt_pro;

--
-- Name: content_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.content_categories_id_seq OWNED BY public.streams_categories.id;


--
-- Name: content_items; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.content_items (
    id integer NOT NULL,
    title character varying(300) NOT NULL,
    slug character varying(300) NOT NULL,
    description text,
    content_type character varying(50) NOT NULL,
    category_id integer,
    source_id integer,
    duration_minutes integer,
    release_year integer,
    rating character varying(20),
    language character varying(10) DEFAULT 'en'::character varying,
    subtitle_languages jsonb DEFAULT '[]'::jsonb,
    genres jsonb DEFAULT '[]'::jsonb,
    imdb_id character varying(50),
    tmdb_id integer,
    tvdb_id integer,
    poster_url character varying(500),
    thumbnail_url character varying(500),
    backdrop_url character varying(500),
    trailer_url character varying(500),
    parent_content_id integer,
    season_number integer,
    episode_number integer,
    server_id integer,
    stream_format character varying(50) DEFAULT 'ts'::character varying,
    video_codec character varying(50),
    audio_codec character varying(50),
    resolution character varying(20),
    bitrate_kbps integer,
    is_adult boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    is_premium boolean DEFAULT false,
    requires_subscription boolean DEFAULT true,
    view_count integer DEFAULT 0,
    download_count integer DEFAULT 0,
    rating_average numeric(3,2) DEFAULT 0.0,
    rating_count integer DEFAULT 0,
    status character varying(20) DEFAULT 'active'::character varying,
    sort_order integer DEFAULT 0,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.content_items OWNER TO xtt_pro;

--
-- Name: content_items_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.content_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_items_id_seq OWNER TO xtt_pro;

--
-- Name: content_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.content_items_id_seq OWNED BY public.content_items.id;


--
-- Name: content_sources; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.content_sources (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    source_type character varying(50) NOT NULL,
    primary_url text,
    backup_urls jsonb DEFAULT '[]'::jsonb,
    user_agent text,
    http_headers jsonb DEFAULT '{}'::jsonb,
    authentication jsonb DEFAULT '{}'::jsonb,
    quality_profiles jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    last_check_at timestamp without time zone,
    last_status character varying(50),
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.content_sources OWNER TO xtt_pro;

--
-- Name: content_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.content_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_sources_id_seq OWNER TO xtt_pro;

--
-- Name: content_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.content_sources_id_seq OWNED BY public.content_sources.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255),
    first_name character varying(100),
    last_name character varying(100),
    reseller_id integer,
    package_id integer,
    status character varying(20) DEFAULT 'active'::character varying,
    max_connections integer DEFAULT 1,
    allowed_ips jsonb DEFAULT '[]'::jsonb,
    allowed_user_agents jsonb DEFAULT '[]'::jsonb,
    force_server_id integer,
    subscription_start_date date,
    subscription_end_date date,
    is_trial boolean DEFAULT false,
    trial_end_date date,
    allowed_devices jsonb DEFAULT '{}'::jsonb,
    device_registration_required boolean DEFAULT false,
    last_login_at timestamp without time zone,
    last_login_ip inet,
    last_activity_at timestamp without time zone,
    failed_login_count integer DEFAULT 0,
    is_locked boolean DEFAULT false,
    locked_until timestamp without time zone,
    billing_cycle character varying(20) DEFAULT 'monthly'::character varying,
    next_billing_date date,
    auto_renewal boolean DEFAULT true,
    admin_notes text,
    reseller_notes text,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO xtt_pro;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO xtt_pro;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: epg_sources; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.epg_sources (
    id integer NOT NULL,
    epg_name character varying(150) NOT NULL,
    epg_file text NOT NULL,
    source_type character varying(50) DEFAULT 'xmltv'::character varying,
    update_frequency_hours integer DEFAULT 24,
    timezone character varying(50) DEFAULT 'UTC'::character varying,
    days_keep integer DEFAULT 7,
    language character varying(10) DEFAULT 'en'::character varying,
    last_update_at timestamp without time zone,
    last_update_status character varying(50),
    is_active boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    epg_offset integer DEFAULT 0,
    data text
);


ALTER TABLE public.epg_sources OWNER TO xtt_pro;

--
-- Name: epg_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.epg_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.epg_sources_id_seq OWNER TO xtt_pro;

--
-- Name: epg_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.epg_sources_id_seq OWNED BY public.epg_sources.id;


--
-- Name: lines; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.lines (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    member_id integer DEFAULT 1,
    last_ip character varying(50),
    exp_date timestamp without time zone,
    admin_enabled boolean DEFAULT true,
    enabled boolean DEFAULT true,
    admin_notes text,
    reseller_notes text,
    providers jsonb,
    allowed_outputs jsonb,
    max_connections integer DEFAULT 1,
    is_restreamer boolean DEFAULT false,
    is_trial boolean DEFAULT false,
    is_mag boolean DEFAULT false,
    is_e2 boolean DEFAULT false,
    is_stalker boolean DEFAULT false,
    is_isplock boolean DEFAULT false,
    allowed_ips jsonb,
    allowed_ua jsonb,
    pair_id integer,
    force_server_id integer DEFAULT 0,
    as_number character varying(50),
    isp_desc text,
    forced_country character varying(5),
    bypass_ua boolean DEFAULT false,
    play_token character varying(255),
    last_expiration_video timestamp without time zone,
    package_id integer,
    access_token character varying(255),
    contact character varying(255),
    last_activity timestamp without time zone,
    last_activity_array jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    plain_password text
);


ALTER TABLE public.lines OWNER TO xtt_pro;

--
-- Name: lines_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lines_id_seq OWNER TO xtt_pro;

--
-- Name: lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.lines_id_seq OWNED BY public.lines.id;


--
-- Name: live_connections; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.live_connections (
    id integer NOT NULL,
    user_id integer,
    stream_id integer,
    server_id integer,
    ip_address inet NOT NULL,
    user_agent text,
    country_code character varying(5),
    isp character varying(200),
    container character varying(20) DEFAULT 'ts'::character varying,
    quality character varying(50) DEFAULT 'source'::character varying,
    started_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_activity timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    bytes_in bigint DEFAULT 0,
    bytes_out bigint DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    username text,
    session_token text
);


ALTER TABLE public.live_connections OWNER TO xtt_pro;

--
-- Name: live_connections_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.live_connections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.live_connections_id_seq OWNER TO xtt_pro;

--
-- Name: live_connections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.live_connections_id_seq OWNED BY public.live_connections.id;


--
-- Name: live_streams_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.live_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.live_streams_id_seq OWNER TO xtt_pro;

--
-- Name: live_streams; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.live_streams (
    id integer DEFAULT nextval('public.live_streams_id_seq'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    url text NOT NULL,
    decryption_keys jsonb,
    config jsonb,
    is_running boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_access timestamp without time zone,
    start_time timestamp without time zone
);


ALTER TABLE public.live_streams OWNER TO xtt_pro;

--
-- Name: packages; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.packages (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    type integer DEFAULT 0,
    price numeric(10,2) DEFAULT 0.00,
    duration integer DEFAULT 30,
    max_connections integer DEFAULT 1,
    max_streams integer DEFAULT 1,
    enabled boolean DEFAULT true,
    features text DEFAULT ''::text,
    channel_groups text DEFAULT ''::text,
    vod_enabled boolean DEFAULT false,
    catchup_enabled boolean DEFAULT false,
    adult_content boolean DEFAULT false,
    trial_period integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.packages OWNER TO xtt_pro;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.packages_id_seq OWNER TO xtt_pro;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.packages_id_seq OWNED BY public.packages.id;


--
-- Name: provider_streams; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.provider_streams (
    provider_id integer NOT NULL,
    stream_id integer NOT NULL
);


ALTER TABLE public.provider_streams OWNER TO xtt_pro;

--
-- Name: server_metrics; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.server_metrics (
    id integer NOT NULL,
    server_id integer NOT NULL,
    cpu_usage_percent numeric(5,2),
    memory_usage_percent numeric(5,2),
    disk_usage_percent numeric(5,2),
    network_in_mbps numeric(10,2),
    network_out_mbps numeric(10,2),
    active_connections integer,
    uptime_seconds integer,
    load_average numeric(10,2),
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.server_metrics OWNER TO xtt_pro;

--
-- Name: server_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.server_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_metrics_id_seq OWNER TO xtt_pro;

--
-- Name: server_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.server_metrics_id_seq OWNED BY public.server_metrics.id;


--
-- Name: servers; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.servers (
    id integer NOT NULL,
    server_name character varying(100) NOT NULL,
    domain_name character varying(255),
    server_ip inet,
    vpn_ip inet,
    location character varying(100),
    datacenter character varying(100),
    server_type character varying(50) DEFAULT 'streaming'::character varying,
    total_clients integer DEFAULT 1000,
    active_clients integer DEFAULT 0,
    cpu_cores integer,
    memory_gb integer,
    storage_gb integer,
    bandwidth_mbps integer,
    http_port integer DEFAULT 8080,
    https_port integer DEFAULT 8443,
    rtmp_port integer DEFAULT 1935,
    ssh_port integer DEFAULT 22,
    ssh_username character varying(100),
    ssh_key_path text,
    monitoring_enabled boolean DEFAULT true,
    load_balance_weight integer DEFAULT 100,
    notes text,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ssh_password character varying(255) DEFAULT ''::character varying,
    http_broadcast_port integer DEFAULT 8080,
    https_broadcast_port integer DEFAULT 8443,
    https_ports character varying(255) DEFAULT ''::character varying,
    igmp_enabled boolean DEFAULT false,
    enable_https boolean DEFAULT true,
    network_interface character varying(255) DEFAULT ''::character varying,
    latency double precision DEFAULT 0.0,
    cpu double precision DEFAULT 0.0,
    gpu character varying(255) DEFAULT ''::character varying,
    gpu_usage double precision DEFAULT 0.0,
    uptime integer DEFAULT 0,
    load_average character varying(255) DEFAULT ''::character varying,
    bytes_sent bigint DEFAULT 0,
    bytes_received bigint DEFAULT 0,
    status boolean DEFAULT true
);


ALTER TABLE public.servers OWNER TO xtt_pro;

--
-- Name: servers_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.servers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servers_id_seq OWNER TO xtt_pro;

--
-- Name: servers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.servers_id_seq OWNED BY public.servers.id;


--
-- Name: short_links; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.short_links (
    code text NOT NULL,
    kind text NOT NULL,
    auth text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.short_links OWNER TO xtt_pro;

--
-- Name: streaming_servers; Type: VIEW; Schema: public; Owner: xtt_pro
--

CREATE VIEW public.streaming_servers AS
 SELECT servers.id,
    servers.server_name,
    servers.server_ip,
    servers.status AS enabled,
    NULL::integer AS server_order
   FROM public.servers;


ALTER TABLE public.streaming_servers OWNER TO xtt_pro;

--
-- Name: streams; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.streams (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    category_id jsonb DEFAULT '[]'::jsonb,
    stream_display_name character varying(255) NOT NULL,
    stream_source jsonb DEFAULT '[]'::jsonb,
    stream_icon character varying(500),
    notes text,
    created_channel_id integer DEFAULT 0,
    epg_id character varying(100),
    epg_channel_id character varying(100),
    epg_lang character varying(10),
    "order" integer DEFAULT 0,
    enable_tv boolean DEFAULT false,
    tv_archive_duration integer DEFAULT 0,
    direct_source boolean DEFAULT false,
    tv_genre character varying(100),
    custom_sid character varying(100),
    xmltv_id character varying(100),
    target_container character varying(20),
    transcode_attributes jsonb DEFAULT '{}'::jsonb,
    is_adult boolean DEFAULT false,
    stream_all_sources boolean DEFAULT false,
    proxy_multi jsonb DEFAULT '{}'::jsonb,
    proxy_multi_source jsonb DEFAULT '{}'::jsonb,
    added timestamp without time zone,
    series_no integer,
    season_num integer,
    container_extension character varying(10),
    movie_image character varying(500),
    movie_language character varying(50),
    movie_subtitles jsonb DEFAULT '{}'::jsonb,
    read boolean DEFAULT false,
    tmdb_id integer,
    releasedate character varying(20),
    youtube character varying(255),
    director_id integer,
    tmdb_rating numeric(3,1),
    backdrop_path jsonb DEFAULT '{}'::jsonb,
    youtube_trailer character varying(255),
    runtime integer,
    series_id integer,
    provider_id integer,
    decryption_kid_and_keys text,
    user_agent text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    server_id integer,
    enabled boolean DEFAULT true
);


ALTER TABLE public.streams OWNER TO xtt_pro;

--
-- Name: streams_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.streams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.streams_id_seq OWNER TO xtt_pro;

--
-- Name: streams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.streams_id_seq OWNED BY public.streams.id;


--
-- Name: streams_servers; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.streams_servers (
    stream_id integer NOT NULL,
    server_id integer NOT NULL,
    pid integer DEFAULT 0,
    monitor_pid integer DEFAULT 0,
    stream_status integer DEFAULT 0
);


ALTER TABLE public.streams_servers OWNER TO xtt_pro;

--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    category character varying(100) NOT NULL,
    key character varying(255) NOT NULL,
    value text,
    value_type character varying(50) DEFAULT 'string'::character varying,
    display_name character varying(255) NOT NULL,
    description text,
    is_public boolean DEFAULT false,
    is_readonly boolean DEFAULT false,
    validation_rules jsonb DEFAULT '{}'::jsonb,
    sort_order integer DEFAULT 0,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_settings OWNER TO xtt_pro;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.system_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_settings_id_seq OWNER TO xtt_pro;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: user_activity_logs; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.user_activity_logs (
    id integer NOT NULL,
    user_id integer,
    customer_id integer,
    activity_type character varying(50) NOT NULL,
    target_type character varying(50) NOT NULL,
    target_id integer,
    target_name character varying(255),
    action_description text,
    old_values jsonb,
    new_values jsonb,
    ip_address inet,
    user_agent text,
    credits_before numeric(10,2),
    credits_after numeric(10,2),
    cost numeric(10,2) DEFAULT 0.00,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_activity_logs OWNER TO xtt_pro;

--
-- Name: user_activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.user_activity_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_activity_logs_id_seq OWNER TO xtt_pro;

--
-- Name: user_activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.user_activity_logs_id_seq OWNED BY public.user_activity_logs.id;


--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.user_groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_admin boolean DEFAULT false,
    is_reseller boolean DEFAULT false,
    permissions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_groups OWNER TO xtt_pro;

--
-- Name: user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_groups_id_seq OWNER TO xtt_pro;

--
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.user_groups_id_seq OWNED BY public.user_groups.id;


--
-- Name: user_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.user_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_logs_id_seq OWNER TO xtt_pro;

--
-- Name: user_logs; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.user_logs (
    id integer DEFAULT nextval('public.user_logs_id_seq'::regclass) NOT NULL,
    reseller_id integer,
    target_type text,
    target_id integer,
    target_name text,
    action text,
    action_details text,
    cost numeric,
    credits_before numeric,
    credits_after numeric,
    ip_address inet,
    created_at timestamp with time zone
);


ALTER TABLE public.user_logs OWNER TO xtt_pro;

--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.user_sessions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    session_token character varying(255) NOT NULL,
    ip_address inet,
    user_agent text,
    expires_at timestamp without time zone NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_sessions OWNER TO xtt_pro;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.user_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_sessions_id_seq OWNER TO xtt_pro;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    user_group_id integer,
    parent_user_id integer,
    status character varying(20) DEFAULT 'active'::character varying,
    last_login timestamp without time zone,
    last_login_ip inet,
    timezone character varying(50) DEFAULT 'UTC'::character varying,
    locale character varying(10) DEFAULT 'en'::character varying,
    credits numeric(10,2) DEFAULT 0.00,
    api_key character varying(255),
    notes text,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password character varying(255),
    enabled boolean DEFAULT true,
    member_group_id integer,
    theme character varying(50) DEFAULT 'dark'::character varying
);


ALTER TABLE public.users OWNER TO xtt_pro;

--
-- Name: users_groups; Type: TABLE; Schema: public; Owner: xtt_pro
--

CREATE TABLE public.users_groups (
    id integer NOT NULL,
    group_name character varying(100) NOT NULL,
    description text,
    allowed_pages jsonb DEFAULT '{}'::jsonb,
    is_admin boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    min_length jsonb DEFAULT '{}'::jsonb,
    reseller_max_buy integer DEFAULT 0,
    reseller_max_connections integer DEFAULT 0,
    is_reseller boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.users_groups OWNER TO xtt_pro;

--
-- Name: users_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.users_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_groups_id_seq OWNER TO xtt_pro;

--
-- Name: users_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.users_groups_id_seq OWNED BY public.users_groups.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: xtt_pro
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO xtt_pro;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: xtt_pro
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: access_codes id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.access_codes ALTER COLUMN id SET DEFAULT nextval('public.access_codes_id_seq'::regclass);


--
-- Name: billing_transactions id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.billing_transactions ALTER COLUMN id SET DEFAULT nextval('public.billing_transactions_id_seq'::regclass);


--
-- Name: connection_sessions id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.connection_sessions ALTER COLUMN id SET DEFAULT nextval('public.connection_sessions_id_seq'::regclass);


--
-- Name: content_items id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items ALTER COLUMN id SET DEFAULT nextval('public.content_items_id_seq'::regclass);


--
-- Name: content_sources id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_sources ALTER COLUMN id SET DEFAULT nextval('public.content_sources_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: epg_sources id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.epg_sources ALTER COLUMN id SET DEFAULT nextval('public.epg_sources_id_seq'::regclass);


--
-- Name: lines id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.lines ALTER COLUMN id SET DEFAULT nextval('public.lines_id_seq'::regclass);


--
-- Name: live_connections id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.live_connections ALTER COLUMN id SET DEFAULT nextval('public.live_connections_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.packages ALTER COLUMN id SET DEFAULT nextval('public.packages_id_seq'::regclass);


--
-- Name: providers id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.providers ALTER COLUMN id SET DEFAULT nextval('public.bouquets_id_seq'::regclass);


--
-- Name: server_metrics id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.server_metrics ALTER COLUMN id SET DEFAULT nextval('public.server_metrics_id_seq'::regclass);


--
-- Name: servers id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.servers ALTER COLUMN id SET DEFAULT nextval('public.servers_id_seq'::regclass);


--
-- Name: streams id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams ALTER COLUMN id SET DEFAULT nextval('public.streams_id_seq'::regclass);


--
-- Name: streams_categories id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_categories ALTER COLUMN id SET DEFAULT nextval('public.content_categories_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: user_activity_logs id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_activity_logs ALTER COLUMN id SET DEFAULT nextval('public.user_activity_logs_id_seq'::regclass);


--
-- Name: user_groups id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_groups ALTER COLUMN id SET DEFAULT nextval('public.user_groups_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_groups id; Type: DEFAULT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users_groups ALTER COLUMN id SET DEFAULT nextval('public.users_groups_id_seq'::regclass);


--
-- Data for Name: access_codes; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: backup_lines; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: backup_servers; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: backup_users; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: billing_transactions; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: connection_sessions; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: content_items; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: content_sources; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: epg_sources; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: lines; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: live_connections; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: live_streams; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: provider_streams; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: server_metrics; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: servers; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: short_links; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: streams; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: streams_categories; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: streams_servers; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: user_activity_logs; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: user_logs; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Data for Name: users_groups; Type: TABLE DATA; Schema: public; Owner: xtt_pro
--



--
-- Name: access_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.access_codes_id_seq', 9, true);


--
-- Name: billing_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.billing_transactions_id_seq', 1, false);


--
-- Name: bouquets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.bouquets_id_seq', 17, true);


--
-- Name: connection_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.connection_sessions_id_seq', 1, false);


--
-- Name: content_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.content_categories_id_seq', 18, true);


--
-- Name: content_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.content_items_id_seq', 1, false);


--
-- Name: content_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.content_sources_id_seq', 1, false);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.customers_id_seq', 1, false);


--
-- Name: epg_sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.epg_sources_id_seq', 7, true);


--
-- Name: lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.lines_id_seq', 4, true);


--
-- Name: live_connections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.live_connections_id_seq', 602, true);


--
-- Name: live_streams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.live_streams_id_seq', 79, true);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.packages_id_seq', 1, false);


--
-- Name: server_metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.server_metrics_id_seq', 1, false);


--
-- Name: servers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.servers_id_seq', 2, true);


--
-- Name: streams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.streams_id_seq', 50, true);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 12, true);


--
-- Name: user_activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.user_activity_logs_id_seq', 1, false);


--
-- Name: user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.user_groups_id_seq', 1, false);


--
-- Name: user_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.user_logs_id_seq', 89, true);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 1, false);


--
-- Name: users_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.users_groups_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: xtt_pro
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: access_codes access_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.access_codes
    ADD CONSTRAINT access_codes_code_key UNIQUE (code);


--
-- Name: access_codes access_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.access_codes
    ADD CONSTRAINT access_codes_pkey PRIMARY KEY (id);


--
-- Name: billing_transactions billing_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.billing_transactions
    ADD CONSTRAINT billing_transactions_pkey PRIMARY KEY (id);


--
-- Name: provider_streams bouquet_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.provider_streams
    ADD CONSTRAINT bouquet_streams_pkey PRIMARY KEY (provider_id, stream_id);


--
-- Name: providers bouquets_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT bouquets_pkey PRIMARY KEY (id);


--
-- Name: connection_sessions connection_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.connection_sessions
    ADD CONSTRAINT connection_sessions_pkey PRIMARY KEY (id);


--
-- Name: streams_categories content_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_categories
    ADD CONSTRAINT content_categories_pkey PRIMARY KEY (id);


--
-- Name: streams_categories content_categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_categories
    ADD CONSTRAINT content_categories_slug_key UNIQUE (slug);


--
-- Name: content_items content_items_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_pkey PRIMARY KEY (id);


--
-- Name: content_items content_items_slug_content_type_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_slug_content_type_key UNIQUE (slug, content_type);


--
-- Name: content_sources content_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_sources
    ADD CONSTRAINT content_sources_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers customers_username_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_username_key UNIQUE (username);


--
-- Name: epg_sources epg_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.epg_sources
    ADD CONSTRAINT epg_sources_pkey PRIMARY KEY (id);


--
-- Name: lines lines_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_pkey PRIMARY KEY (id);


--
-- Name: lines lines_username_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.lines
    ADD CONSTRAINT lines_username_key UNIQUE (username);


--
-- Name: live_connections live_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.live_connections
    ADD CONSTRAINT live_connections_pkey PRIMARY KEY (id);


--
-- Name: live_streams live_streams_name_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.live_streams
    ADD CONSTRAINT live_streams_name_key UNIQUE (name);


--
-- Name: live_streams live_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.live_streams
    ADD CONSTRAINT live_streams_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: server_metrics server_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.server_metrics
    ADD CONSTRAINT server_metrics_pkey PRIMARY KEY (id);


--
-- Name: servers servers_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.servers
    ADD CONSTRAINT servers_pkey PRIMARY KEY (id);


--
-- Name: short_links short_links_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.short_links
    ADD CONSTRAINT short_links_pkey PRIMARY KEY (code);


--
-- Name: streams streams_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams
    ADD CONSTRAINT streams_pkey PRIMARY KEY (id);


--
-- Name: streams_servers streams_servers_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_servers
    ADD CONSTRAINT streams_servers_pkey PRIMARY KEY (stream_id, server_id);


--
-- Name: system_settings system_settings_category_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_category_setting_key_key UNIQUE (category, key);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: user_activity_logs user_activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_activity_logs
    ADD CONSTRAINT user_activity_logs_pkey PRIMARY KEY (id);


--
-- Name: user_groups user_groups_name_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_name_key UNIQUE (name);


--
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: user_logs user_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_logs
    ADD CONSTRAINT user_logs_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_session_token_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_session_token_key UNIQUE (session_token);


--
-- Name: users users_api_key_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_api_key_key UNIQUE (api_key);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_groups users_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT users_groups_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_bouquet_streams_stream; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_bouquet_streams_stream ON public.provider_streams USING btree (stream_id);


--
-- Name: idx_lines_exp_date; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_lines_exp_date ON public.lines USING btree (exp_date);


--
-- Name: idx_live_conn_active; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_live_conn_active ON public.live_connections USING btree (is_active, last_activity);


--
-- Name: idx_live_conn_token; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_live_conn_token ON public.live_connections USING btree (session_token);


--
-- Name: idx_live_conn_user_stream; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_live_conn_user_stream ON public.live_connections USING btree (user_id, stream_id);


--
-- Name: idx_live_streams_is_running; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_live_streams_is_running ON public.live_streams USING btree (is_running);


--
-- Name: idx_live_streams_name; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_live_streams_name ON public.live_streams USING btree (name);


--
-- Name: idx_provider_streams_stream; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_provider_streams_stream ON public.provider_streams USING btree (stream_id);


--
-- Name: idx_short_links_expires; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_short_links_expires ON public.short_links USING btree (expires_at);


--
-- Name: idx_short_links_kind; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_short_links_kind ON public.short_links USING btree (kind);


--
-- Name: idx_streams_enabled; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_streams_enabled ON public.streams USING btree (enabled);


--
-- Name: idx_streams_provider; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_streams_provider ON public.streams USING btree (provider_id);


--
-- Name: idx_streams_servers_server; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_streams_servers_server ON public.streams_servers USING btree (server_id);


--
-- Name: idx_system_settings_key; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_system_settings_key ON public.system_settings USING btree (key);


--
-- Name: idx_user_logs_action; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_user_logs_action ON public.user_logs USING btree (action);


--
-- Name: idx_user_logs_created_at; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_user_logs_created_at ON public.user_logs USING btree (created_at);


--
-- Name: idx_user_logs_reseller; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE INDEX idx_user_logs_reseller ON public.user_logs USING btree (reseller_id);


--
-- Name: uq_streams_categories_slug; Type: INDEX; Schema: public; Owner: xtt_pro
--

CREATE UNIQUE INDEX uq_streams_categories_slug ON public.streams_categories USING btree (slug);


--
-- Name: live_streams update_live_streams_updated_at; Type: TRIGGER; Schema: public; Owner: xtt_pro
--

CREATE TRIGGER update_live_streams_updated_at BEFORE UPDATE ON public.live_streams FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: access_codes access_codes_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.access_codes
    ADD CONSTRAINT access_codes_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: billing_transactions billing_transactions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.billing_transactions
    ADD CONSTRAINT billing_transactions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: billing_transactions billing_transactions_processed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.billing_transactions
    ADD CONSTRAINT billing_transactions_processed_by_fkey FOREIGN KEY (processed_by) REFERENCES public.users(id);


--
-- Name: billing_transactions billing_transactions_reseller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.billing_transactions
    ADD CONSTRAINT billing_transactions_reseller_id_fkey FOREIGN KEY (reseller_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: provider_streams bouquet_streams_bouquet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.provider_streams
    ADD CONSTRAINT bouquet_streams_bouquet_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE CASCADE;


--
-- Name: provider_streams bouquet_streams_stream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.provider_streams
    ADD CONSTRAINT bouquet_streams_stream_id_fkey FOREIGN KEY (stream_id) REFERENCES public.streams(id) ON DELETE CASCADE;


--
-- Name: connection_sessions connection_sessions_access_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.connection_sessions
    ADD CONSTRAINT connection_sessions_access_code_id_fkey FOREIGN KEY (access_code_id) REFERENCES public.access_codes(id) ON DELETE SET NULL;


--
-- Name: connection_sessions connection_sessions_content_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.connection_sessions
    ADD CONSTRAINT connection_sessions_content_item_id_fkey FOREIGN KEY (content_item_id) REFERENCES public.content_items(id) ON DELETE SET NULL;


--
-- Name: connection_sessions connection_sessions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.connection_sessions
    ADD CONSTRAINT connection_sessions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: connection_sessions connection_sessions_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.connection_sessions
    ADD CONSTRAINT connection_sessions_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.servers(id) ON DELETE SET NULL;


--
-- Name: streams_categories content_categories_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_categories
    ADD CONSTRAINT content_categories_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: streams_categories content_categories_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_categories
    ADD CONSTRAINT content_categories_parent_category_id_fkey FOREIGN KEY (parent_id) REFERENCES public.streams_categories(id) ON DELETE SET NULL;


--
-- Name: content_items content_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.streams_categories(id) ON DELETE SET NULL;


--
-- Name: content_items content_items_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: content_items content_items_parent_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_parent_content_id_fkey FOREIGN KEY (parent_content_id) REFERENCES public.content_items(id) ON DELETE CASCADE;


--
-- Name: content_items content_items_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.servers(id) ON DELETE SET NULL;


--
-- Name: content_items content_items_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_items
    ADD CONSTRAINT content_items_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.content_sources(id) ON DELETE SET NULL;


--
-- Name: content_sources content_sources_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.content_sources
    ADD CONSTRAINT content_sources_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: customers customers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: customers customers_force_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_force_server_id_fkey FOREIGN KEY (force_server_id) REFERENCES public.servers(id) ON DELETE SET NULL;


--
-- Name: customers customers_reseller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_reseller_id_fkey FOREIGN KEY (reseller_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: epg_sources epg_sources_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.epg_sources
    ADD CONSTRAINT epg_sources_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: server_metrics server_metrics_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.server_metrics
    ADD CONSTRAINT server_metrics_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.servers(id) ON DELETE CASCADE;


--
-- Name: servers servers_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.servers
    ADD CONSTRAINT servers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: streams streams_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams
    ADD CONSTRAINT streams_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id);


--
-- Name: streams_servers streams_servers_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_servers
    ADD CONSTRAINT streams_servers_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.servers(id) ON DELETE CASCADE;


--
-- Name: streams_servers streams_servers_stream_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.streams_servers
    ADD CONSTRAINT streams_servers_stream_id_fkey FOREIGN KEY (stream_id) REFERENCES public.streams(id) ON DELETE CASCADE;


--
-- Name: system_settings system_settings_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: user_activity_logs user_activity_logs_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_activity_logs
    ADD CONSTRAINT user_activity_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: user_activity_logs user_activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_activity_logs
    ADD CONSTRAINT user_activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: users users_parent_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_parent_user_id_fkey FOREIGN KEY (parent_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: users users_user_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: xtt_pro
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_user_group_id_fkey FOREIGN KEY (user_group_id) REFERENCES public.user_groups(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict e4Taw1PLg7vDAz1pevDZibQBbU8hNuULVBY44Yq5OMEZ3glXJXHez1tOjIVbaOf

