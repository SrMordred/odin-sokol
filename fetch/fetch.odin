package fetch

/*
    TODO:
    This binding is incomplete:
    I´m just binding what i´m using atm.
    Pull request are welcome :)
*/

import "core:c"

uint32_t :: c.uint;
bool   :: c.bool;

when ODIN_OS == "windows" do foreign import sfetch_lib "system:sokol_fetch.lib"

@(default_calling_convention="c")
foreign sfetch_lib 
{
	sfetch_setup :: proc (desc: ^Desc) ---
 	sfetch_send  :: proc (request: ^Request ) -> Handle ---
    @(link_name="sfetch_shutdown") shutdown :: proc () ---
    @(link_name="sfetch_dowork")   dowork :: proc () ---

}

setup :: proc(desc: Desc) {
    d := desc;
    sfetch_setup(&d);
}

tmp : Request;

send :: proc(request: Request) -> Handle{
    tmp = request;
    return sfetch_send(&tmp);
}

Callback :: proc "c" ( ^Response );

Error :: enum i32 {
    NO_ERROR,
    FILE_NOT_FOUND,
    NO_BUFFER,
    BUFFER_TOO_SMALL,
    UNEXPECTED_EOF,
    INVALID_HTTP_STATUS,
    CANCELLED
}

Desc :: struct
{
	_start_canary 	: uint32_t,
	max_requests 	: uint32_t,          /* max number of active requests across all channels, default is 128 */
	num_channels 	: uint32_t,          /* number of channels to fetch requests in parallel, default is 1 */
	num_lanes 		: uint32_t,             /* max number of requests active on the same channel, default is 1 */
	_end_canary 	: uint32_t,
}

Handle :: struct
{
	id: uint32_t
}

Request :: struct
{
	_start_canary	: uint32_t,
    channel			: uint32_t,               /* index of channel this request is assigned to (default: 0) */
    path			: cstring,               /* filesystem path or HTTP URL (required) */
    callback		: Callback,     /* response callback function pointer (required) */
    buffer_ptr		: rawptr,               /* buffer pointer where data will be loaded into (optional) */
    buffer_size		: uint32_t,           /* buffer size in number of bytes (optional) */
    chunk_size		: uint32_t,            /* number of bytes to load per stream-block (optional) */
    user_data_ptr	: cstring,      /* pointer to a POD user-data block which will be memcpy'd(!) (optional) */
    user_data_size	: uint32_t,        /* size of user-data block (optional) */
    _end_canary		: uint32_t,
}

Response :: struct
{
    handle			: Handle,         /* request handle this response belongs to */
    dispatched		: bool,                /* true when request is in DISPATCHED state (lane has been assigned) */
    fetched			: bool,                   /* true when request is in FETCHED state (fetched data is available) */
    paused			: bool,                    /* request is currently in paused state */
    finished		: bool,                  /* this is the last response for this request */
    failed			: bool,                    /* request has failed (always set together with 'finished') */
    cancelled		: bool,                 /* request was cancelled (always set together with 'finished') */
    error_code		: Error,      /* more detailed error code when failed is true */
    channel			: uint32_t,               /* the channel which processes this request */
    lane			: uint32_t,                  /* the lane this request occupies on its channel */
    path			: cstring,               /* the original filesystem path of the request (FIXME : this is unsafe, wrap in API call?) */
    user_data		: rawptr,                /* pointer to read/write user-data area (FIXME	: this is unsafe, wrap in API call?) */
    fetched_offset	: uint32_t,        /* current offset of fetched data chunk in file data */
    fetched_size	: uint32_t,          /* size of fetched data chunk in number of bytes */
    buffer_ptr		: rawptr,               /* pointer to buffer with fetched data */
    buffer_size		: uint32_t,           /* overall buffer size (may be >= than fetched_size!) */
}
