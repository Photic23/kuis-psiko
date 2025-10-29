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
			// In dev: allow inline & eval; In prod: allow inline for Next's critical inline scripts
			`script-src 'self' 'unsafe-inline' ${isDev ? "'unsafe-eval' 'wasm-unsafe-eval'" : ''}`.trim(),
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
