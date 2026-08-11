export const QwenSystemMerge = async ({ client }) => {
  await client.app.log({
    body: {
      service: "qwen-system-merge",
      level: "info",
      message: "plugin loaded",
    },
  })

  return {
    "experimental.chat.system.transform": async (_input, output) => {
      const parts = output.system.filter(
        (x) => typeof x === "string" && x.trim().length > 0,
      )

      await client.app.log({
        body: {
          service: "qwen-system-merge",
          level: "info",
          message: `system fragments before merge: ${parts.length}`,
        },
      })

      if (parts.length <= 1) return

      output.system.splice(
        0,
        output.system.length,
        parts.join("\n\n"),
      )
    },
  }
}
