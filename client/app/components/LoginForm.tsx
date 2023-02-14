import Link from "next/link";
import Button from "./Button";
import Input from "./Input";

export default function LoginForm() {
  return (
    <section className="flex min-h-screen items-center justify-center bg-white">
      <div className="flex w-1/4 flex-col items-center justify-center gap-6 rounded-2xl bg-cyan-200 p-4 shadow-sm shadow-cyan-400">
        <div className="flex w-full justify-center border-b border-solid border-gray-400 p-2 text-center">
          <span className="text-2xl font-medium">Log in</span>
        </div>

        <div className="flex w-full flex-col justify-center gap-2">
          <div className="flex flex-col">
            <Input value="Username or Email" type="text" />
          </div>
          <div className="flex flex-col">
            <Input value="Password" type="password" />
          </div>
        </div>
        <div className="h-10 w-full rounded-md bg-green-600 transition-all hover:bg-green-700">
          <Button text="Log in" />
        </div>
        <div>
          Not a member?{" "}
          <Link href={"/register"}>
            <span className="font-semibold text-purple-600">Sign up</span>
          </Link>
        </div>
      </div>
    </section>
  );
}
