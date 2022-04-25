import type { NextPage } from 'next'
import Image from 'next/image'
import logo from './logo.png'

const Home: NextPage = () => {
  return (
    <div>
      <Image src={logo} alt="PaimonMenuBar logo" height={140} width={140} />
      <h1 className="font-bold text-xl">PaimonMenuBar</h1>
    </div>
  )
}

export default Home
