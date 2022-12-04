const hello = async event => ({
	statusCode: 200,
	body: JSON.stringify({
		message: "ok from my code",
		input: event
	}),
});

export default hello;
