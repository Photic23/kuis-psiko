/** @type {import('next').NextConfig} */
const nextConfig = {
	reactStrictMode: true,
	experimental: {
		typedRoutes: true,
	},
	headers: async () => {
		const isDev = process.env.NODE_ENV !== 'production';
		const csp = [
			"default-src 'self'",
			`script-src 'self' ${isDev ? "'unsafe-inline' 'unsafe-eval' 'wasm-unsafe-eval'" : ''}`.trim(),
			"style-src 'self' 'unsafe-inline'",
			"img-src 'self' data: blob:",
			"connect-src 'self' https://*.supabase.co",
			"font-src 'self' data:",
			"frame-ancestors 'self'",
			"base-uri 'self'",
			"form-action 'self'",
		].filter(Boolean).join('; ');
		return [
			{
				source: '/(.*)',
				headers: [
					{
						key: 'Content-Security-Policy',
						value: csp,
					},
				],
			},
		];
	},
};

export default nextConfig;
