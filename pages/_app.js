import Link from 'next/link'
import '../styles/globals.css'

function MyApp({ Component, pageProps }) {
  return (
    <div>
      {/* sets the border as b and padding with 6 */}
      <nav className="boarder-b p-6">
        <p className='text-4xl font-bold'> Metaverse marketplace</p>
        <div className='flex mt-4'>
          <Link href="/">
            <a className='mr-6 text-pink-500'>
              Home
            </a>
          </Link>
          <Link href="/create-nft">
            <a className='mr-6 text-pink-500'>
              Create NFT
            </a>
          </Link>
          <Link href="/my-assets">
            <a className='mr-6 text-pink-500'>
              My Digital Assets
            </a>
          </Link>
          <Link href="/dashboard">
            <a className='mr-6 text-pink-500'>
              Creator Dashboard
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default MyApp
